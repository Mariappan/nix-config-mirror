{ self, inputs, ... }:
{
  flake.nixosConfigurations.vim3 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit self inputs;
    };
    modules = [
      inputs.disko.nixosModules.disko

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
          nixma.users.maari = {
            email = "1221719+nappairam@users.noreply.github.com";
            sshKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/gQaDONy7ryuW8R7tsnUxxpEoqQ1erZuM4KOb3VLAc maari@tetra"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB3JnJ0u7pwetXhzAmskHUmxfQjcCtoyModO+IRKL89 homelab@1password"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P xv@1password"
              # air root nix-builder pubkey — lets air dispatch aarch64 builds here.
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJoWEudOuTi8ffSKq+y4fEQAy06vXoGTgBxsl2DUHem root@air"
            ];
            gitSignByDefault = false;
          };

          nixma.nixos = {
            formFactor = "sbc";
            roles = [ "server" ];
          };

          nixma.nixos.hardware = {
            hostPlatform = "aarch64-linux";
            cpu.vendor = null;
            filesystems.manage = false;
          };

          # Boot: u-boot on the SoC (OOWOW lives in SPI on this board). NixOS
          # writes a generic-extlinux-compatible config that u-boot consumes
          # from /boot — no NixOS-managed loader (systemd-boot/grub/limine).
          nixma.nixos.boot = {
            bootloader = "none";
            kernelPackage = "latest";
            initrd.network.enable = false;
          };

          boot.loader.generic-extlinux-compatible.enable = true;
          # boot.nix sets bootloader = "none" but doesn't disable grub since
          # nixpkgs defaults grub.enable = true. Switch off explicitly so the
          # toplevel assertion ("set grub.devices") doesn't fire.
          boot.loader.grub.enable = false;
          # G12B mainline kernel needs the meson/Amlogic dtbs from the kernel
          # package; let the bootloader copy the matching A311D dtb on switch.
          hardware.deviceTree.enable = true;
          hardware.deviceTree.name = "amlogic/meson-g12b-a311d-khadas-vim3.dtb";
          # Filter the bundled dtbs tree to just our board so /boot doesn't
          # carry ~129 MiB of irrelevant SoC DTBs.
          hardware.deviceTree.filter = "meson-g12b-a311d-khadas-vim3*.dtb";

          networking.hostName = "vim3";
          time.timeZone = "Asia/Singapore";

          nixma.nixos.networking.backend = "networkd";

          # Wake-on-LAN via magic packet on the gigabit ethernet (RTL8211F).
          # MAC: c8:63:14:70:46:be — `wakeonlan c8:63:14:70:46:be` from air.
          networking.interfaces.end0.wakeOnLan.enable = true;

          # ethtool for poking PHY WOL state directly when debugging wake
          # sources (e.g. `sudo ethtool -s end0 wol d` to confirm whether
          # Linux WOL is the unintended wake trigger).
          environment.systemPackages = [ pkgs.ethtool ];

          # No RTC battery on VIM3 → clock resets on power loss; same DNSSEC
          # workaround as rock3c so the first NTP query can resolve.
          services.resolved.settings.Resolve.DNSSEC = lib.mkForce "false";

          nix.settings.trusted-users = [
            "root"
            "maari"
          ];

          boot.growPartition = true;
          fileSystems."/".autoResize = true;

          # eMMC wear / RAM tightness mitigations:
          #  - zram swap so nix shell + builds don't OOM (3.7 GiB RAM is tight)
          zramSwap = {
            enable = true;
            algorithm = "zstd";
            memoryPercent = 75;
          };

          nixma.nixos.boot.tmpfs = {
            enable = true;
            size = "2G";
          };

          fileSystems."/".options = [ "noatime" ];
          fileSystems."/boot".options = [ "noatime" ];

          # Boot partition starts at 16 MiB to leave room for any later
          # bootloader installation in the GPT pre-MBR area.
          disko = {
            imageBuilder.extraPostVM = "";
            memSize = lib.mkDefault 4096;
            devices.disk.main = {
              type = "disk";
              imageSize = lib.mkDefault "4G";
              content = {
                type = "gpt";
                partitions = {
                  boot = {
                    type = "EF00";
                    start = "16M";
                    size = "512M";
                    content = {
                      type = "filesystem";
                      format = "vfat";
                      mountpoint = "/boot";
                      mountOptions = [ "umask=0022" ];
                    };
                  };
                  root = {
                    size = "100%";
                    content = {
                      type = "filesystem";
                      format = "ext4";
                      mountpoint = "/";
                    };
                  };
                };
              };
            };
          };

          nix.settings.system-features = [
            "kvm"
            "big-parallel"
            "benchmark"
          ];
        }
      )
    ];
  };
}
