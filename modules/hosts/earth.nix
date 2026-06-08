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
        { ... }:
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
