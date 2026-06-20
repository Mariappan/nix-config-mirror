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

          systemd.network.networks."05-virtual-unmanaged" = {
            matchConfig.Name = "wg-br veth* podman*";
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
              echo "$WG_CN" > /run/pia/cn
              echo "registered fresh PIA WG key for region $REGION ($WG_CN)"
            '';
          };
          systemd.services.wg = {
            requires = [ "pia-wg-conf.service" ];
            after = [ "pia-wg-conf.service" ];
          };

          # PIA's forwarded port is dynamic: sign once, then bindPort every <15min
          # keeps it alive (payload lasts ~2 months; bindPort needs no token). The
          # PF API is only reachable through the tunnel, so confine to the wg ns;
          # push the port to qBittorrent on change (in-ns API, subnet-whitelisted).
          systemd.services.pia-portforward = {
            description = "PIA port forwarding -> qBittorrent";
            wantedBy = [ "multi-user.target" ];
            requires = [
              "pia-wg-conf.service"
              "wg.service"
            ];
            after = [
              "pia-wg-conf.service"
              "wg.service"
              "qbittorrent.service"
            ];
            path = with pkgs; [
              curl
              jq
              coreutils
            ];
            serviceConfig = {
              Restart = "always";
              RestartSec = 30;
              EnvironmentFile = "/etc/pia/pia.env";
            };
            vpnConfinement = {
              enable = true;
              vpnNamespace = "wg";
            };
            script = ''
              set -euo pipefail
              CA=${self + /dotfiles/certs/pia-ca.rsa.4096.crt}
              GW=$(cat /run/pia/gateway)
              CN=$(cat /run/pia/cn)

              pf_call() {
                curl -s -G --max-time 15 --connect-to "$CN::$GW:" --cacert "$CA" "$@"
              }

              TOK=$(cat /run/pia/token 2>/dev/null || true)
              SIG=$(pf_call --data-urlencode "token=$TOK" "https://$CN:19999/getSignature")
              if [ "$(echo "$SIG" | jq -r .status)" != OK ]; then
                echo "boot token rejected; fetching a fresh one"
                TOK=$(curl -s --max-time 15 --location --request POST \
                  'https://www.privateinternetaccess.com/api/client/v2/token' \
                  --form "username=$PIA_USER" --form "password=$PIA_PASS" | jq -r '.token // empty')
                SIG=$(pf_call --data-urlencode "token=$TOK" "https://$CN:19999/getSignature")
                [ "$(echo "$SIG" | jq -r .status)" = OK ] || { echo "getSignature failed: $SIG"; exit 1; }
              fi

              PAYLOAD=$(echo "$SIG" | jq -r .payload)
              SIGNATURE=$(echo "$SIG" | jq -r .signature)
              PORT=$(echo "$PAYLOAD" | base64 -d | jq -r .port)
              echo "PIA forwarded port: $PORT"

              # re-push every cycle: heals a qbittorrent restart resetting the port
              while true; do
                BIND=$(pf_call --data-urlencode "payload=$PAYLOAD" --data-urlencode "signature=$SIGNATURE" \
                  "https://$CN:19999/bindPort")
                [ "$(echo "$BIND" | jq -r .status)" = OK ] || { echo "bindPort failed: $BIND"; exit 1; }
                curl -s --max-time 10 \
                  --data "json={\"listen_port\": $PORT, \"random_port\": false}" \
                  http://192.168.15.1:8085/api/v2/app/setPreferences > /dev/null || true
                sleep 600
              done
            '';
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
              openTcpPorts = [ 8080 ];
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

          # The official container (with bundled, matched Chrome) —
          # the nixpkgs build crashes against nixpkgs Chromium.
          virtualisation.oci-containers = {
            backend = "podman";
            containers.flaresolverr = {
              image = "ghcr.io/flaresolverr/flaresolverr:v3.5.0";
              ports = [ "127.0.0.1:8191:8191" ];
              environment.LOG_LEVEL = "info";
            };
          };
          systemd.services.podman-flaresolverr = {
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
          };

          services.caddy =
            let
              tlsFiles = ''
                tls /mnt/arr-certs/arr.crt /mnt/arr-certs/arr.key
              '';
              proxy = upstream: ''
                ${tlsFiles}
                reverse_proxy ${upstream} {
                  header_down Access-Control-Allow-Origin "https://nas.lab.nappairam.dev"
                }
              '';
            in
            {
              enable = true;
              virtualHosts = {
                "qbit.arr.lab.nappairam.dev".extraConfig = proxy "localhost:8080";
                "prowl.arr.lab.nappairam.dev".extraConfig = proxy "localhost:9696";
                "son.arr.lab.nappairam.dev".extraConfig = proxy "localhost:8989";
                "rad.arr.lab.nappairam.dev".extraConfig = proxy "localhost:7878";
                "baz.arr.lab.nappairam.dev".extraConfig = proxy "localhost:6767";
              };
            };
          # wait for the virtiofs cert mount; caddy can't start without the files
          systemd.services.arr-certs-wait = {
            description = "Wait for the virtiofs-shared arr certs";
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              for i in $(seq 1 60); do
                [ -e /mnt/arr-certs/arr.key ] && exit 0
                sleep 2
              done
              echo "arr-certs mount never appeared" >&2
              exit 1
            '';
          };
          systemd.services.caddy = {
            requires = [ "arr-certs-wait.service" ];
            after = [ "arr-certs-wait.service" ];
          };
          # caddy doesn't watch manually-loaded cert files; pick up renewals daily
          systemd.services.caddy-reload = {
            description = "Reload caddy to pick up renewed certs";
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.systemd}/bin/systemctl reload caddy.service";
            };
          };
          systemd.timers.caddy-reload = {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = "daily";
              Persistent = true;
            };
          };

          # 443 only, and only from the LAN
          networking.firewall.extraInputRules = ''
            ip saddr 10.89.10.0/24 tcp dport 443 accept
          '';

          networking.hostName = "arr";
          time.timeZone = "Asia/Singapore";
        }
      )
    ];
  };
}
