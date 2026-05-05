{ self, inputs, ... }:
{
  flake.nixosConfigurations.tetra = inputs.nixpkgs.lib.nixosSystem {
    modules = [

      # Base
      self.modules.nixos.common

      # Features
      self.modules.nixos.docker
      self.modules.nixos.niri
      self.modules.nixos.nvidia
      self.modules.nixos.virtualbox

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
            email = "1221719+nappairam@users.noreply.github.com";
            sshKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/gQaDONy7ryuW8R7tsnUxxpEoqQ1erZuM4KOb3VLAc maari@tetra"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB3JnJ0u7pwetXhzAmskHUmxfQjcCtoyModO+IRKL89 homelab@1password"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P xv@1password"
            ];
            gitSignByDefault = false;

            # HM features (replaces bundle-tetra)
            hmModules = with self.modules.homeManager; [
              moderntools
              git
              jujutsu
              rust
              dev
              debug
              gpgagent
              earthly
              niri
              claude
            ];
          };

          # Profile
          nixma.nixos.formFactor = "desktop";
          nixma.nixos.roles = [ "workstation" ];

          # Hardware configuration
          nixma.nixos.hardware = {
            work.enable = false;
            swap.enable = true;
            cpu.vendor = "intel";
          };

          # Boot configuration
          nixma.nixos.boot = {
            bootloader = "limine";
            limine.resolution = "2560x1440x32";
            limine.interfaceResolution = "2560x1440";
            limine.extraEntries = ''
              /Windows
                protocol: efi
                path: uuid(49528857-1fbd-4704-bd60-b5891b3840a7):/EFI/Microsoft/Boot/bootmgfw.efi
            '';
            kernelModules = [ "kvm-intel" ];
            initrd.availableKernelModules = [
              "nvme"
              "xhci_pci"
              "thunderbolt"
              "ahci"
              "usbhid"
              "usb_storage"
              "sd_mod"
            ];
          };

          nixma.nixos.networking.strictArp = true;

          home-manager.sharedModules = [
            {
              home.packages = lib.mkIf pkgs.stdenv.isLinux [
                pkgs.google-chrome
                pkgs.spotify
                pkgs.spotify-player
                pkgs.obsidian
                pkgs.nushell
                pkgs._2511.gpclient
                pkgs.pavucontrol
                pkgs.ookla-speedtest
                pkgs.nrfutil
                pkgs.lmstudio
              ];
            }
          ];

          networking.hostName = "tetra";
          time.timeZone = "Asia/Singapore";
          programs.mosh.enable = true;
        }
      )
    ];
  };
}
