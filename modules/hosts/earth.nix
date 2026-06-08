# earth — NAS; stable channel for ZFS/kernel sanity.
{ self, inputs, ... }:
{
  flake.nixosConfigurations.earth = inputs.nixpkgs-2605.lib.nixosSystem {
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
        { ... }:
        {
          nixma.users.maari = {
            email = "1221719+nappairam@users.noreply.github.com";
            sshKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/gQaDONy7ryuW8R7tsnUxxpEoqQ1erZuM4KOb3VLAc maari@tetra"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB3JnJ0u7pwetXhzAmskHUmxfQjcCtoyModO+IRKL89 homelab@1password"
            ];
            extraGroups = [ "incus-admin" ];

            hmModules = with self.modules.homeManager; [
              git
            ];
          };

          nixma.nixos.formFactor = "desktop";
          nixma.nixos.roles = [ "server" ];

          nixma.nixos.hardware = {
            cpu.vendor = "amd";
          };

          nixma.nixos.boot = {
            kernelModules = [ "kvm-amd" ];
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

          networking.hostName = "earth";
          time.timeZone = "Asia/Singapore";
        }
      )
    ];
  };
}
