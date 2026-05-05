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
      self.modules.nixos.shared-fonts

      # Features
      self.modules.nixos."1password"
      self.modules.nixos.zen-browser
      self.modules.nixos.bluetooth
      self.modules.nixos.docker
      self.modules.nixos.fprint
      self.modules.nixos.hidraw
      self.modules.nixos.laptop
      self.modules.nixos.niri
      self.modules.nixos.plymouth
      self.modules.nixos.screenrecorder
      self.modules.nixos.sound
      self.modules.nixos.virtualbox
      self.modules.nixos.gpclient
      self.modules.nixos.kmscon
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
          nixma.nixos.gpclient = {
            enable = true;
            interface = "gpd0";
            secrets = {
              networksFile = self + /secrets/gpclient-networks-air.age;
              domainsFile = self + /secrets/gpclient-domains-air.age;
              configFile = self + /secrets/gpclient-config-air.age;
            };
          };

          boot.loader.timeout = 3;

          nixma.nixos.networking.tailscale = true;
          nixma.nixos.networking.strictArp = true;

          home-manager.sharedModules = [
            {
              home.packages = lib.mkIf pkgs.stdenv.isLinux [
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
            enable = true;
            machines.indiarpi = {
              hostName = "indiarpi.bittern-pirate.ts.net";
              sshUser = "maari";
              systems = [ "aarch64-linux" ];
              maxJobs = 4;
              # Pi5 with /dev/kvm available — supports kvm-accelerated builds.
              supportedFeatures = [ "kvm" "big-parallel" "benchmark" ];
            };
          };

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
