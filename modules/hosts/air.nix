{ self, inputs, ... }:
{
  flake.nixosConfigurations.air = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen
      inputs.agenix.nixosModules.default
      inputs.noctalia.nixosModules.default
      inputs.home-manager.nixosModules.home-manager

      # Base
      self.modules.nixos.common
      self.modules.nixos.hardware
      self.modules.nixos.boot
      self.modules.nixos.networking
      self.modules.nixos.i18n
      self.modules.nixos.nix
      self.modules.nixos.shared-fonts

      # Features
      self.modules.nixos."1password"
      self.modules.nixos.zen-browser
      self.modules.nixos.bluetooth
      self.modules.nixos.docker
      self.modules.nixos.fprint
      self.modules.nixos.hidraw
      self.modules.nixos.laptop
      self.modules.nixos.manpages
      self.modules.nixos.niri
      self.modules.nixos.plymouth
      self.modules.nixos.screenrecorder
      self.modules.nixos.sound
      self.modules.nixos.veila
      self.modules.nixos.virtualbox
      self.modules.nixos.gpclient

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
            email = "142216110+kp-mariappan-ramasamy@users.noreply.github.com";
            sshKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P 1passwordxvpn"
            ];
            gitSigningKey = "3B7DA4A8AF8C211443B571A2AD921C91A406F32D";
            gitSignByDefault = true;

            # HM features (replaces bundle-air)
            hmModules = with self.modules.homeManager; [
              desktop
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
              veila
              {
                nixma.veila.settings = {
                  theme = "boracay";
                  background = {
                    mode = "file";
                    path = builtins.path {
                      path = self + /wallpapers/outbreak-wallpaper-2880x1800.jpg;
                      name = "veila-wallpaper.jpg";
                    };
                  };
                  visuals = {
                    clock.color = "#B22A2A";
                    date.color = "#B22A2A";
                    input = {
                      border_color = "#ffffff";
                      mask_color = "#ffffff";
                    };
                    placeholder.color = "#ffffff";
                    username.color = "#ffffff";
                  };
                };
              }
            ];
          };

          # Hardware configuration
          nixma.nixos.hardware = {
            work.enable = true;
            swap.enable = true;
            cpu.vendor = "intel";
          };

          # Boot configuration
          nixma.nixos.boot = {
            bootloader = "limine";
            kernelPackage = "default";
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

          # GlobalProtect VPN split tunneling
          age.secrets.gpclient-networks.file = self + /secrets/gpclient-networks-air.age;
          age.secrets.gpclient-domains.file = self + /secrets/gpclient-domains-air.age;

          age.secrets.gpclient-config = {
            file = self + /secrets/gpclient-config-air.age;
            owner = "maari";
            mode = "0400";
          };
          nixma.nixos.gpclient = {
            interface = "gpd0";
            splitTunnelNetworksFile = config.age.secrets.gpclient-networks.path;
            splitTunnelDomainsFile = config.age.secrets.gpclient-domains.path;
          };

          boot.loader.timeout = 3;

          nixma.nixos.networking.tailscale = true;
          nixma.nixos.networking.strictArp = true;

          # GlobalProtect config for noctalia plugin (env vars from agenix secret)
          home-manager.sharedModules = [
            {
              systemd.user.tmpfiles.rules = lib.mkIf pkgs.stdenv.isLinux [
                "L %h/.config/environment.d/500-gpconfig.conf - - - - /run/agenix/gpclient-config"
              ];

              home.packages = lib.mkIf pkgs.stdenv.isLinux [
                pkgs.google-chrome
                pkgs.slack
                pkgs.spotify
                pkgs.spotify-player
                pkgs.obsidian
                pkgs.remmina
                pkgs.nushell
                pkgs.claude-code-bin
                pkgs._2511.gpclient
                pkgs.pavucontrol
                pkgs.awscli2
                pkgs.aws-sso-cli
                pkgs.ookla-speedtest
                pkgs.zed-editor
                pkgs.karere
              ];
            }
          ];

          networking.hostName = "air";
          time.timeZone = "Asia/Singapore";

          services.printing.enable = true;
          services.fwupd.enable = true;

          programs.yubikey-touch-detector.enable = true;
          programs.vscode.enable = true;
          programs.vscode.extensions = with pkgs.vscode-extensions; [
            ms-vsliveshare.vsliveshare
            rust-lang.rust-analyzer
          ];

          services.logind.settings.Login.HandlePowerKey = "ignore";

          services.udev.extraRules = ''
            ACTION=="remove",\
             ENV{ID_BUS}=="usb",\
             ENV{ID_MODEL_ID}=="0407",\
             ENV{ID_VENDOR_ID}=="1050",\
             ENV{ID_VENDOR}=="Yubico",\
             RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
          '';
        }
      )
    ];
  };
}
