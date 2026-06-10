# arr — isolated NixOS Incus VM for the *arr stack (assume-breach).
{ self, inputs, ... }:
{
  flake.nixosConfigurations.arr = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      homeManagerModule = inputs.home-manager.nixosModules.home-manager;
    };
    modules = [
      "${inputs.nixpkgs}/nixos/modules/virtualisation/incus-virtual-machine.nix"

      # Base
      self.modules.nixos.common

      # Bundles
      self.modules.nixos.server

      # *arr stack (native services + VPN confinement)
      inputs.nixarr.nixosModules.default

      # Users
      self.modules.nixos.user-maari
      self.modules.nixos.user-root

      (
        { lib, pkgs, ... }:
        {
          nixma.users.maari = {
            email = "1221719+nappairam@users.noreply.github.com";
            sshKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/gQaDONy7ryuW8R7tsnUxxpEoqQ1erZuM4KOb3VLAc maari@tetra"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB3JnJ0u7pwetXhzAmskHUmxfQjcCtoyModO+IRKL89 homelab@1password"
            ];
          };

          nixma.nixos.formFactor = "desktop";
          nixma.nixos.roles = [ "server" ];

          nixma.nixos.hardware.cpu.vendor = "amd";

          # The Incus VM module owns the bootloader + filesystems.
          nixma.nixos.boot.bootloader = "none";
          nixma.nixos.hardware.filesystems.manage = false;
          # No encrypted disk → no initrd remote-unlock SSH (its host-key secret
          # is absent in the image-build sandbox and breaks bootloader install).
          nixma.nixos.boot.initrd.network.enable = false;

          nixma.nixos.networking.backend = "networkd";

          systemd.network.networks."05-vpn-confinement" = {
            matchConfig.Name = "wg-br veth-wg-br";
            linkConfig.Unmanaged = true;
          };

          # PIA purges WireGuard key registrations after short inactivity, so a
          # static wg.conf dies whenever the VM is down for a while. Register a
          # fresh key at every boot instead (token -> addKey -> /run/pia/wg.conf),
          # before VPN-Confinement's wg.service reads it. Credentials live in a
          # root-only /etc/pia/pia.env provisioned manually (see README).
          systemd.services.pia-wg-conf = {
            description = "Register a WireGuard key with PIA and write /run/pia/wg.conf";
            wantedBy = [ "multi-user.target" ];
            before = [ "wg.service" ];
            wants = [ "network-online.target" ];
            after = [ "network-online.target" ];
            path = with pkgs; [
              curl
              jq
              wireguard-tools
            ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              EnvironmentFile = "/etc/pia/pia.env";
            };
            script = ''
              set -euo pipefail
              umask 077
              mkdir -p /run/pia

              REGION=$(echo "''${PIA_REGION:-sg}" | tr 'A-Z' 'a-z')
              [ "$REGION" = singapore ] && REGION=sg

              TOK=""
              for attempt in $(seq 1 30); do
                TOK=$(curl -s --max-time 15 --location --request POST \
                  'https://www.privateinternetaccess.com/api/client/v2/token' \
                  --form "username=$PIA_USER" --form "password=$PIA_PASS" \
                  | jq -r '.token // empty') && [ -n "$TOK" ] && break
                echo "token attempt $attempt failed; retrying"
                sleep 5
              done
              [ -n "$TOK" ] || { echo "could not get PIA token"; exit 1; }

              SRV=$(curl -s --max-time 15 'https://serverlist.piaservers.net/vpninfo/servers/v6' | head -1)
              WG_IP=$(echo "$SRV" | jq -r --arg r "$REGION" '.regions[] | select(.id==$r) | .servers.wg[0].ip')
              WG_CN=$(echo "$SRV" | jq -r --arg r "$REGION" '.regions[] | select(.id==$r) | .servers.wg[0].cn')
              { [ -n "$WG_IP" ] && [ "$WG_IP" != null ]; } || { echo "region $REGION not found"; exit 1; }

              PRIV=$(wg genkey)
              PUB=$(echo "$PRIV" | wg pubkey)
              RESP=$(curl -s -G --max-time 15 \
                --connect-to "$WG_CN::$WG_IP:" \
                --cacert ${self + /dotfiles/certs/pia-ca.rsa.4096.crt} \
                --data-urlencode "pt=$TOK" --data-urlencode "pubkey=$PUB" \
                "https://$WG_CN:1337/addKey")
              [ "$(echo "$RESP" | jq -r .status)" = OK ] || { echo "addKey failed: $RESP"; exit 1; }

              {
                echo "[Interface]"
                echo "Address = $(echo "$RESP" | jq -r .peer_ip)"
                echo "PrivateKey = $PRIV"
                echo "DNS = $(echo "$RESP" | jq -r '.dns_servers[0]')"
                echo ""
                echo "[Peer]"
                echo "PublicKey = $(echo "$RESP" | jq -r .server_key)"
                echo "AllowedIPs = 0.0.0.0/0"
                echo "Endpoint = $WG_IP:1337"
                echo "PersistentKeepalive = 25"
              } > /run/pia/wg.conf

              # for the port-forward helper
              echo "$TOK" > /run/pia/token
              echo "$WG_IP" > /run/pia/gateway
              echo "registered fresh PIA WG key for region $REGION ($WG_CN)"
            '';
          };
          systemd.services.wg = {
            requires = [ "pia-wg-conf.service" ];
            after = [ "pia-wg-conf.service" ];
          };

          # Pin the media group to the host's gid so files the VM writes through
          # virtiofs land as group `media` (2000) on the host
          users.groups.media.gid = lib.mkForce 2000;

          # *arr stack as native NixOS services
          nixarr = {
            enable = true;
            mediaDir = "/data";
            stateDir = "/var/lib/nixarr";

            # Only qBittorrent rides the PIA tunnel (kill-switched netns);
            # the *arr apps go direct (indexers/trackers block VPN IPs).
            vpn = {
              enable = true;
              wgConf = "/run/pia/wg.conf";
              openTcpPorts = [ 8080 ]; # qBittorrent WebUI, reachable for Caddy
            };

            prowlarr.enable = true;
            sonarr.enable = true;
            radarr.enable = true;
            bazarr.enable = true;

            qbittorrent = {
              enable = true;
              webuiPort = 8080;
              vpn.enable = true;
            };
          };

          networking.hostName = "arr";
          time.timeZone = "Asia/Singapore";
        }
      )
    ];
  };
}
