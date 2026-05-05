{ self, inputs, ... }:
{
  flake.nixosConfigurations.dull5080 = inputs.nixpkgs.lib.nixosSystem {
    modules = [

      # Base
      self.modules.nixos.common
      self.modules.nixos.hardware
      self.modules.nixos.boot
      self.modules.nixos.networking

      # Features
      self.modules.nixos.docker
      self.modules.nixos.headless

      # Users
      self.modules.nixos.user-maari
      self.modules.nixos.user-root

      (
        { ... }:
        {
          nixma.users.maari = {
            email = "1221719+nappairam@users.noreply.github.com";
            sshKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/gQaDONy7ryuW8R7tsnUxxpEoqQ1erZuM4KOb3VLAc maari@tetra"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB3JnJ0u7pwetXhzAmskHUmxfQjcCtoyModO+IRKL89 homelab@1password"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P xv@1password"
            ];
            extraGroups = [ "incus-admin" ];
            gitSignByDefault = false;

            # HM features (replaces bundle-dull5080)
            hmModules = with self.modules.homeManager; [
              moderntools
              git
              jujutsu
            ];
          };

          # Profile
          nixma.nixos.formFactor = "desktop";
          nixma.nixos.roles = [ "server" ];

          # Hardware configuration
          nixma.nixos.hardware = {
            cpu.vendor = "intel";
          };

          # Boot configuration
          nixma.nixos.boot = {
            kernelModules = [ "kvm-intel" ];
            initrd.availableKernelModules = [
              "ahci"
              "nvme"
              "xhci_pci"
              "usbhid"
              "usb_storage"
              "sd_mod"
            ];
          };

          networking.hostName = "dull5080";
          time.timeZone = "Asia/Singapore";
        }
      )
    ];
  };
}
