{ self, inputs, ... }:
let
  rock3cInputs = {
    inherit (inputs)
      self
      home-manager
      agenix
      noctalia
      nix-index-database
      nix-alien
      flake-parts
      ;
    nixpkgs = inputs.nixpkgs-rock3c;
    nixos-hardware = inputs.nixos-hardware-rock3c;
  };
in
{
  flake.nixosConfigurations.rock3c = inputs.nixpkgs-rock3c.lib.nixosSystem {
    specialArgs = {
      inherit self;
      inputs = rock3cInputs;
    };
    modules = [
      inputs.nixos-hardware-rock3c.nixosModules.rock-3c
      inputs.disko.nixosModules.disko
      "${inputs.nixos-hardware-rock3c}/rockchip/disko.nix"

      # Base
      self.modules.nixos.common

      # Bundles
      self.modules.nixos.server

      # Users
      self.modules.nixos.user-maari
      self.modules.nixos.user-root

      (
        { lib, pkgs, ... }:
        {
          # Default 2 GiB is too small for the rock3c closure (kernel +
          # linux-firmware alone is ~700 MiB). Bump to 4 GiB so the disko
          # imageBuilder VM has room for the full system store copy.
          disko.devices.disk.main.imageSize = lib.mkForce "4G";

          nixma.users.maari = {
            email = "1221719+nappairam@users.noreply.github.com";
            sshKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/gQaDONy7ryuW8R7tsnUxxpEoqQ1erZuM4KOb3VLAc maari@tetra"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB3JnJ0u7pwetXhzAmskHUmxfQjcCtoyModO+IRKL89 homelab@1password"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P xv@1password"
            ];
            gitSignByDefault = false;
          };

          # Profile: SBC form factor + headless server role.
          nixma.nixos = {
            formFactor = "sbc";
            roles = [ "server" ];
          };

          # Hardware: aarch64 SBC, no x86 microcode, disko manages filesystems
          nixma.nixos.hardware = {
            hostPlatform = "aarch64-linux";
            cpu.vendor = null;
            filesystems.manage = false;
          };

          # Boot: u-boot + radxa systemd-boot wired by nixos-hardware
          nixma.nixos.boot = {
            bootloader = "none";
            initrd.network.enable = false;
          };

          networking.hostName = "rock3c";
          time.timeZone = "Asia/Singapore";

          # Lean network stack — drops NetworkManager + libqmi (~70 MiB).
          nixma.nixos.networking.backend = "networkd";

          # Rock3C has no RTC battery → clock resets to epoch on power loss.
          # systemd-resolved DNSSEC then rejects "future" signatures, blocking
          # NTP's own DNS lookup before time sync. Disable strict DNSSEC so the
          # first NTP query can resolve the pool host.
          services.resolved.settings.Resolve.DNSSEC = lib.mkForce "false";

          # NixOS-native partition grow on first boot (initrd-level growpart).
          # Preserves the disk-main-root partlabel disko set up.
          boot.growPartition = true;

          # Firmware needed for rock3c:
          #   brcm + cypress: AP6256 (BCM43455) wifi + bluetooth.
          #   rockchip: DisplayPort TX (dptx.bin) blob loaded by rk3568 DRM.
          hardware.firmware = [
            (pkgs.runCommand "rock3c-firmware" { } ''
              set -eu
              mkdir -p $out/lib/firmware
              for d in brcm cypress rockchip; do
                src="${pkgs.linux-firmware}/lib/firmware/$d"
                if [ -d "$src" ]; then
                  cp -r "$src" "$out/lib/firmware/"
                else
                  echo "rock3c-firmware: skipping missing subdir $d" >&2
                fi
              done
            '')
          ];

          # Re-enable wireless regulatory database (default-disabled by SBC
          # profile in modules/features/system/hardware.nix).
          hardware.wirelessRegulatoryDatabase = lib.mkForce true;
        }
      )
    ];
  };
}
