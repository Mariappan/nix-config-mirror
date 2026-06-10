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
        { config, lib, ... }:
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
              openTcpPorts = [ 8080 ]; # qBittorrent WebUI, reachable for Caddy
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

          networking.hostName = "arr";
          time.timeZone = "Asia/Singapore";
        }
      )
    ];
  };
}
