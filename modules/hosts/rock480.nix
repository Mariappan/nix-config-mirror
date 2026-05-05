{ self, inputs, ... }:
{
  flake.nixosConfigurations.rock480 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480

      # Base
      self.modules.nixos.common

      # Features
      self.modules.nixos."1password"
      self.modules.nixos.bluetooth
      self.modules.nixos.docker
      self.modules.nixos.fprint
      self.modules.nixos.niri
      self.modules.nixos.plymouth
      self.modules.nixos.screenrecorder
      self.modules.nixos.sound
      self.modules.nixos.zen-browser

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
            email = "2441529-Mariappan@users.noreply.gitlab.com";
            sshKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/gQaDONy7ryuW8R7tsnUxxpEoqQ1erZuM4KOb3VLAc maari@tetra"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB3JnJ0u7pwetXhzAmskHUmxfQjcCtoyModO+IRKL89 homelab@1password"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P xv@1password"
            ];
            gitSignByDefault = false;

            # HM features (replaces bundle-rock480)
            hmModules = with self.modules.homeManager; [
              moderntools
              git
              jujutsu
              dev
              debug
              niri
            ];
          };

          # Profile
          nixma.nixos.formFactor = "laptop";
          nixma.nixos.roles = [ "workstation" ];

          # Hardware configuration
          nixma.nixos.hardware = {
            swap.enable = true;
            cpu.vendor = "intel";
          };

          # Boot configuration
          nixma.nixos.boot = {
            bootloader = "grub";
            grub.efiSupport = false;
            kernelPackage = "latest";
            initrd.availableKernelModules = [
              "xhci_pci"
              "nvme"
              "usbhid"
              "usb_storage"
              "sd_mod"
            ];
          };

          nixma.nixos.networking.strictArp = true;

          home-manager.sharedModules = [
            {
              home.packages = lib.mkIf pkgs.stdenv.isLinux [
                pkgs.claude-code
                pkgs.pavucontrol
                pkgs.ookla-speedtest
                pkgs.ethtool
                pkgs.pciutils
                pkgs.usbutils
                pkgs.lm_sensors
                pkgs.mtr
              ];
            }
          ];

          # Enable GPU acceleration (Intel iGPU) — required for Hyprland performance
          hardware.graphics.enable = true;

          networking.hostName = "rock480";
          time.timeZone = "Asia/Singapore";
          services.printing.enable = true;
        }
      )
    ];
  };
}
