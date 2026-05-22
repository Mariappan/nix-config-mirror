{ self, inputs, ... }:
{
  flake.nixosConfigurations.air = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen

      # Base
      self.modules.nixos.common

      # Bundles + features
      self.modules.nixos.workstation
      self.modules.nixos.laptop
      self.modules.nixos.bluetooth
      self.modules.nixos.fprint
      self.modules.nixos.niri
      self.modules.nixos.docker
      self.modules.nixos.virtualbox
      self.modules.nixos.yubikey
      self.modules.nixos.gpclient
      inputs.expressvpn.nixosModules.default
      self.modules.nixos.remoteBuilders

      # Users
      self.modules.nixos.user-maari
      self.modules.nixos.user-root

      (
        {
          pkgs,
          lib,
          ...
        }:
        {
          nixma.users.maari = {
            email = "142216110+kp-mariappan-ramasamy@users.noreply.github.com";
            sshKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P 1passwordxvpn"
            ];
            gitSigningKey = "3B7DA4A8AF8C211443B571A2AD921C91A406F32D";
            gitSignByDefault = true;

            # HM features (replaces bundle-air)
            hmModules = with self.modules.homeManager; [
              moderntools
              git
              jujutsu
              rust
              dev
              debug
              gpgagent
              earthly
              neovide
              niri
              claude
            ];
          };

          # Profile
          nixma.nixos.formFactor = "laptop";
          nixma.nixos.roles = [ "workstation" ];

          # Hardware configuration
          nixma.nixos.hardware = {
            work.enable = true;
            swap.enable = true;
            cpu.vendor = "intel";
          };

          # Boot configuration
          nixma.nixos.boot = {
            bootloader = "limine";
            kernelPackage = "latest";
            blacklistedKernelModules = [ "kvm-intel" ];
            tmpfs = {
              enable = true;
              size = "8G";
            };
            initrd.availableKernelModules = [
              "xhci_pci"
              "thunderbolt"
              "nvme"
              "usbhid"
              "usb_storage"
              "sd_mod"
              "r8152"
              "rtsx_pci_sdmmc"
            ];
          };

          services.expressvpn = {
            enable = true;
            users = [ "maari" ];
            tailscaleBypass.enable = true;
          };

          # GlobalProtect VPN split tunneling
          nixma.nixos.gpclient = {
            interface = "gpd0";
            secrets = {
              networksFile = self + /secrets/gpclient-networks-air.age;
              domainsFile = self + /secrets/gpclient-domains-air.age;
              configFile = self + /secrets/gpclient-config-air.age;
            };
          };

          nixma.nixos.boot.loaderTimeout = 3;

          nixma.nixos.networking.tailscale = true;
          nixma.nixos.networking.strictArp = true;

          home-manager.sharedModules = [
            {
              home.packages = lib.mkIf pkgs.stdenv.isLinux [
                (pkgs.writeShellApplication {
                  name = "toggle-expressvpn";
                  runtimeInputs = [ pkgs.jq ];
                  text = ''
                    WIN=$(niri msg -j windows | jq -r '[.[] | select(.app_id | ascii_downcase | contains("expressvpn"))] | first | .id // empty')
                    if [ -n "$WIN" ]; then
                        niri msg action close-window --id "$WIN"
                    else
                        expressvpn-client
                    fi
                  '';
                })
                pkgs.google-chrome
                pkgs.slack
                pkgs.spotify
                pkgs.spotify-player
                pkgs.obsidian
                pkgs.remmina
                pkgs.nushell
                pkgs.pavucontrol
                pkgs.awscli2
                pkgs.aws-sso-cli
                pkgs.ookla-speedtest
                pkgs.zed-editor
                pkgs.karere
                pkgs.telegram-desktop
              ];
            }
          ];

          networking.hostName = "air";
          time.timeZone = "Asia/Singapore";

          nixma.nixos.remoteBuilders = {
            # machines.indiarpi = {
            #   hostName = "indiarpi.bittern-pirate.ts.net";
            #   sshUser = "maari";
            #   systems = [ "aarch64-linux" ];
            #   maxJobs = 4;
            #   # Pi5 with /dev/kvm available — supports kvm-accelerated builds.
            #   supportedFeatures = [
            #     "kvm"
            #     "big-parallel"
            #     "benchmark"
            #   ];
            # };
            machines.vim3 = {
              hostName = "10.89.20.101";
              sshUser = "maari";
              systems = [ "aarch64-linux" ];
              # 6 cores (4×A53 + 2×A73) but only 3.7 GiB RAM — keep parallel
              # builds modest to avoid OOM on heavy aarch64 closures.
              maxJobs = 2;
              speedFactor = 1;
              supportedFeatures = [
                "kvm"
                "big-parallel"
                "benchmark"
              ];
            };
          };

          services.printing.enable = true;

          programs.vscode.enable = true;
          programs.vscode.extensions = with pkgs.vscode-extensions; [
            ms-vsliveshare.vsliveshare
            rust-lang.rust-analyzer
          ];

          services.logind.settings.Login.HandlePowerKey = "ignore";
        }
      )
    ];
  };
}
