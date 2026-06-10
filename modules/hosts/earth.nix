# earth — NAS; stable channel for ZFS/kernel sanity.
{ self, inputs, ... }:
{
  flake.nixosConfigurations.earth = inputs.nixpkgs-stable.lib.nixosSystem {
    specialArgs = {
      homeManagerModule = inputs.home-manager-stable.nixosModules.home-manager;
    };
    modules = [

      self.modules.nixos.common

      # Bundles + features
      self.modules.nixos.server
      self.modules.nixos.incus
      self.modules.nixos.zfs

      # Users
      self.modules.nixos.user-maari
      self.modules.nixos.user-root

      (
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          nixma.users.maari = {
            email = "1221719+nappairam@users.noreply.github.com";
            sshKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/gQaDONy7ryuW8R7tsnUxxpEoqQ1erZuM4KOb3VLAc maari@tetra"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB3JnJ0u7pwetXhzAmskHUmxfQjcCtoyModO+IRKL89 homelab@1password"
            ];
            extraGroups = [ "incus-admin" "media" ];

            hmModules = with self.modules.homeManager; [
              git
            ];
          };

          # NAS data-owner accounts
          users.users.maari.uid = 1000;
          users.groups.media.gid = 2000;
          users.groups.safia.gid = 1001;
          users.users.mediarr = {
            isSystemUser = true;
            uid = 2000;
            group = "media";
            description = "Media service account";
          };
          users.users.safia = {
            isSystemUser = true;
            uid = 1001;
            group = "safia";
            extraGroups = [ "media" ];
            description = "Safia";
          };

          nixma.nixos.formFactor = "desktop";
          nixma.nixos.roles = [ "server" ];

          nixma.nixos.hardware = {
            cpu.vendor = "amd";
          };

          nixma.nixos.boot = {
            kernelModules = [
              "kvm-amd"
              "br_netfilter"
            ];
            initrd.availableKernelModules = [
              "ahci"
              "nvme"
              "xhci_pci"
              "usbhid"
              "usb_storage"
              "sd_mod"
            ];
          };

          nixma.nixos.networking.backend = "networkd";

          nixma.nixos.zfs = {
            hostId = "ea27beef";
            extraPools = [
              "datapool"
              "fastpool"
              "backuppool"
            ];
          };

          services.samba = {
            enable = true;
            openFirewall = true;
            settings =
              let
                fruit = "catia fruit streams_xattr";
              in
              {
                global = {
                  "server string" = "earth";
                  security = "user";
                  "min protocol" = "SMB2";
                  "map to guest" = "never";
                  "fruit:aapl" = "yes";
                  "fruit:model" = "MacPro7,1";
                };
                media = {
                  path = "/srv/media";
                  "valid users" = "@media";
                  "read only" = "no";
                  "force group" = "media";
                  "create mask" = "0664";
                  "directory mask" = "2775";
                  "vfs objects" = fruit;
                };
                pictures = {
                  path = "/srv/pictures";
                  "valid users" = "maari safia";
                  "read only" = "no";
                  "vfs objects" = fruit;
                };
                maari = {
                  path = "/srv/maari";
                  "valid users" = "maari";
                  "read only" = "no";
                  "vfs objects" = fruit;
                };
                safia = {
                  path = "/srv/safia";
                  "valid users" = "safia";
                  "read only" = "no";
                  "vfs objects" = fruit;
                };
                megamind = {
                  path = "/srv/megamind";
                  "valid users" = "maari";
                  "read only" = "no";
                  "vfs objects" = fruit;
                };
                temp = {
                  path = "/srv/temp";
                  "valid users" = "maari safia";
                  "read only" = "no";
                  "vfs objects" = fruit;
                };
              };
          };

          services.avahi.publish.userServices = true;
          services.avahi.extraServiceFiles.smb = ''
            <?xml version="1.0" standalone='no'?>
            <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
            <service-group>
              <name replace-wildcards="yes">%h</name>
              <service><type>_smb._tcp</type><port>445</port></service>
              <service><type>_device-info._tcp</type><port>0</port>
                <txt-record>model=MacPro7,1</txt-record></service>
            </service-group>
          '';

          age.secrets.cloudflare-token.file = ../../secrets/cloudflare-token.age;
          services.caddy = {
            enable = true;
            package = pkgs.caddy.withPlugins {
              plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
              hash = "sha256-8yZDrejNKsaUnUaTUFYbarWNmxafqp2z2rWo+XRsxV8=";
            };
            virtualHosts."plex.lab.nappairam.dev".extraConfig = ''
              tls {
                dns cloudflare {env.CLOUDFLARE_API_TOKEN}
                propagation_delay 120s
                propagation_timeout -1
              }
              reverse_proxy localhost:32400
            '';
            # Cert-only
            virtualHosts."*.arr.lab.nappairam.dev".extraConfig = ''
              tls {
                dns cloudflare {env.CLOUDFLARE_API_TOKEN}
                propagation_delay 120s
                propagation_timeout -1
              }
              respond 404
            '';
            virtualHosts.":80".extraConfig = ''
              respond "Caddy is running" 200
            '';
          };
          systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.cloudflare-token.path;
          networking.firewall.allowedTCPPorts = [ 80 443 ];

          # ZFS datasets served by samba/plex — legacy mountpoints (set on import). nofail so a
          # missing/unavailable pool doesn't drop this headless box to emergency mode.
          fileSystems = builtins.listToAttrs (
            map (n: {
              name = "/srv/${n}";
              value = {
                device = "datapool/${n}";
                fsType = "zfs";
                options = [ "nofail" "x-systemd.mount-timeout=10s" ];
              };
            }) [ "media" "plex" "pictures" "maari" "safia" "megamind" "temp" ]
          );

          # Don't start services on an empty mountpoint if the pool isn't up yet.
          systemd.services.plex.unitConfig.RequiresMountsFor = [ "/srv/plex" "/srv/media" ];
          systemd.services.samba-smbd.unitConfig.RequiresMountsFor = [
            "/srv/media"
            "/srv/pictures"
            "/srv/maari"
            "/srv/safia"
            "/srv/megamind"
            "/srv/temp"
          ];

          services.plex = {
            enable = true;
            openFirewall = true;
            dataDir = "/srv/plex";
          };
          users.users.plex.extraGroups = [ "media" "render" "video" ];
          hardware.graphics.enable = true;

          boot.kernel.sysctl = {
            # Since bridge pure L2
            "net.bridge.bridge-nf-call-iptables" = 0;
            "net.bridge.bridge-nf-call-ip6tables" = 0;
          };

          systemd.network = {
            netdevs = {
              "20-vlan100" = {
                netdevConfig = {
                  Name = "vlan100";
                  Kind = "vlan";
                };
                vlanConfig.Id = 100;
              };
              "20-br-iot" = {
                netdevConfig = {
                  Name = "br-iot";
                  Kind = "bridge";
                };
              };
            };
            networks = {
              # Incus VM taps / container veths
              "02-incus-virtual" = {
                matchConfig.Name = "tap* veth*";
                linkConfig.Unmanaged = true;
              };
              # Uplink: untagged DHCP + carry tagged VLAN100 up.
              "05-uplink" = {
                matchConfig.Name = "enp196s0";
                networkConfig.DHCP = "yes";
                vlan = [ "vlan100" ];
              };
              # Tagged VLAN100 frames → br-iot (L2 only)
              "06-vlan100" = {
                matchConfig.Name = "vlan100";
                networkConfig.Bridge = "br-iot";
                linkConfig.RequiredForOnline = "no";
              };
              # Pure L2 bridge
              "07-br-iot" = {
                matchConfig.Name = "br-iot";
                networkConfig = {
                  DHCP = "no";
                  LinkLocalAddressing = "no";
                  IPv6AcceptRA = false;
                };
                linkConfig.RequiredForOnline = "no";
              };
            };
          };

          networking.hostName = "earth";
          time.timeZone = "Asia/Singapore";
        }
      )
    ];
  };
}
