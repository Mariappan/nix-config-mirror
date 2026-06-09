{ self, inputs, ... }:
let
  chipInputs = {
    inherit (inputs)
      self
      home-manager
      agenix
      noctalia
      nix-index-database
      nix-alien
      flake-parts
      ;
    nixos-hardware = inputs.nixos-hardware-chip;
  };
in
{
  flake.nixosConfigurations.chip = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit self;
      inputs = chipInputs;
      homeManagerModule = inputs.home-manager.nixosModules.home-manager;
    };
    modules = [
      # Hardware: Next Thing Co CHIP (Allwinner R8, armv7l).
      # The fork-nixos-hardware "chip" branch carries upstream PR #1807 which
      # is not yet merged.
      inputs.nixos-hardware-chip.nixosModules.nextthing-chip
      # Wraps nixos-installer/sd-card/sd-image.nix so `system.build.sdImage`
      # produces a flashable image with the extlinux-compatible bootloader.
      "${inputs.nixos-hardware-chip}/nextthing/chip/image.nix"

      # Base
      self.modules.nixos.common

      # Bundles
      self.modules.nixos.server

      # Users
      self.modules.nixos.user-maari
      self.modules.nixos.user-root

      (
        { config, lib, pkgs, ... }:
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
          };

          # Profile: SBC form factor + headless server role.
          nixma.nixos = {
            formFactor = "sbc";
            roles = [ "server" ];
          };

          # CHIP is armv7l (Allwinner R8 Cortex-A8). No x86 microcode; let
          # the sd-image module own /, /boot via fileSystems.
          nixma.nixos.hardware = {
            hostPlatform = "armv7l-linux";
            cpu.vendor = null;
            filesystems.manage = false;
          };

          # Cross-compile from x86_64 (avoids needing an armv7l-linux builder
          # or qemu-user binfmt on an aarch64 box like vim3).
          nixpkgs.buildPlatform.system = "x86_64-linux";

          # CHIP has an RTL8723BS combo Wi-Fi/BT chip. The kernel driver
          # (r8723bs) lives in chip/bluetooth.nix's initrd available list,
          # but nothing auto-loads it at runtime - force it. Pull the
          # rtlwifi + rtl_bt firmware blobs from linux-firmware (skipped on
          # SBC by default to keep closure small). g_ether for USB-OTG
          # ethernet gadget is also wired here in the same kernelModules list.
          boot.kernelModules = [
            "r8723bs"
            "g_ether"
          ];

          # r8723bs ships defaults that advertise HT/40MHz/SGI capabilities
          # the 1T1R radio can't actually do. AP rejects association with
          # 802.11 status_code=1 (UNSPECIFIED_FAILURE) until HT is disabled
          # entirely. With these params the driver associates cleanly with
          # WPA2-PSK CCMP networks.
          # - rtw_ht_enable=0: disable 802.11n HT capabilities entirely
          # - rtw_bw_mode=0:   force 20MHz channel width
          # - rtw_power_mgnt=0: no power-save (improves stability)
          # - rtw_ips_mode=0:  no idle-power-save (radio stays on)
          # - rtw_wifi_spec=1: strict 802.11 spec compliance for QoS/WMM
          boot.extraModprobeConfig = ''
            options r8723bs rtw_ht_enable=0 rtw_bw_mode=0 rtw_power_mgnt=0 rtw_ips_mode=0 rtw_wifi_spec=1
          '';

          # Kernel 6.18 regression: with CONFIG_RESET_GPIO=y the reset
          # framework upgrades `reset-gpios` into a reset_controller, but
          # the gpio fallback in drivers/reset/core.c hardcodes
          # `args_count != 2` -> -ENOENT. sunxi pinctrl uses #gpio-cells=3
          # (bank, pin, flags), so mmc-pwrseq-simple's probe fails with
          # "reset control not ready" -> mmc0 deferred forever -> no SDIO
          # -> no wlan0. Disabling the reset-gpio shim makes pwrseq_simple
          # fall back to plain devm_gpiod_get_array which handles any cell
          # count.
          boot.kernelPatches = [
            {
              name = "disable-reset-gpio-3cell-incompatible";
              patch = null;
              structuredExtraConfig = with lib.kernel; {
                RESET_GPIO = no;
              };
            }
          ];
          hardware.firmware = [
            (pkgs.runCommand "rtl8723bs-firmware" { } ''
              mkdir -p $out/lib/firmware
              cp -r ${pkgs.linux-firmware}/lib/firmware/rtlwifi $out/lib/firmware/
              cp -r ${pkgs.linux-firmware}/lib/firmware/rtl_bt  $out/lib/firmware/
            '')
          ];

          # nextthing-chip/common.nix enables hardware.graphics for Mali 400.
          # Headless server doesn't render — drop it to skip mesa + llvm +
          # vulkan-loader (~150 MiB).
          hardware.graphics.enable = lib.mkForce false;

          # Default CHIP u-boot puts FDT at 0x43000000 (kernel_addr_r+16MiB).
          # NixOS zImage at 6.18 expands past 16 MiB → overlaps FDT slot.
          # Sunxi defines these as C macros in include/configs/sunxi-common.h
          # (not Kconfig), so extraConfig CONFIG_FDT_ADDR_R has no effect.
          # Instead use CONFIG_USE_PREBOOT to override fdt_addr_r/ramdisk_addr_r
          # in the saved env before bootcmd runs.
          nixpkgs.overlays = [
            (_final: prev: {
              ubootCHIP = prev.ubootCHIP.override (old: {
                extraConfig = (old.extraConfig or "") + ''
                  CONFIG_USE_PREBOOT=y
                  CONFIG_PREBOOT="setenv fdt_addr_r 0x43800000; setenv ramdisk_addr_r 0x44000000"
                '';
              });
            })
          ];

          # fish has a Rust xtask helper that doesn't cross-compile cleanly
          # (links against the native pcre2 instead of the armv7l one).
          # Drop fish on chip and use zsh (kept by shared-shells) instead.
          # Disable at every layer that pulls fish: NixOS programs, login
          # shell, and home-manager.
          programs.fish.enable = lib.mkForce false;
          users.users.maari.shell = lib.mkForce pkgs.zsh;
          users.users.root.shell = lib.mkForce pkgs.zsh;
          home-manager.sharedModules = [
            { programs.fish.enable = lib.mkForce false; }
          ];

          # Boot path: u-boot SPL -> u-boot -> generic-extlinux-compatible
          # is set by nixos-hardware/nextthing/chip/common.nix as mkDefault.
          # We skip our local bootloader config to avoid clobbering it.
          nixma.nixos.boot = {
            bootloader = "none";
            initrd.network.enable = false;
          };

          networking.hostName = "chip";
          time.timeZone = "Asia/Singapore";

          # First-boot recovery creds; change after initial setup.
          users.users.root.initialPassword = "chip";
          users.users.maari.initialPassword = "chip";

          # CHIP has no RTC battery: same DNSSEC chicken/egg with NTP that
          # rock3c hits. Disable strict DNSSEC so initial NTP resolves.
          services.resolved.settings.Resolve.DNSSEC = lib.mkForce "false";

          # Lean network stack — drop NetworkManager + libqmi.
          nixma.nixos.networking.backend = "networkd";

          # mDNS reflector - bridges Bonjour/AirPlay/Chromecast/HomeKit
          # discovery across VLANs that share this host. Open firewall on
          # mDNS (UDP 5353).
          services.avahi = {
            enable = true;
            openFirewall = true;
            reflector = true;
            ipv4 = true;
            ipv6 = true;
            publish = {
              enable = true;
              addresses = true;
              workstation = true;
            };
            # Limit reflection to VLAN-tagged interfaces. Adjust this list
            # to whatever interfaces sit on the VLANs you want bridged
            # (e.g. "wlan0.10", "wlan0.20", "usb0").
            # allowInterfaces = [ "wlan0" "usb0" ];
          };

          # NixOS systemd-hardening generates SystemCallFilter targeting
          # x86_64 syscall numbers. On armv7l some entries (e.g. setgroups)
          # map to different numbers and the seccomp filter SIGSYS-kills
          # the daemon. Drop the filter so avahi can call setgroups.
          systemd.services.avahi-daemon.serviceConfig.SystemCallFilter =
            lib.mkForce [ ];

          # CHIP has no Ethernet - Wi-Fi is the only path. The NixOS
          # `networking.wireless` module wires wpa_supplicant.service with
          # a namespace-mounted secret file (agenix); that fails on a
          # fresh image because the host's ssh ed25519 key is generated
          # AFTER activation, so agenix can't decrypt anything on first
          # boot. To break the chicken-egg, skip the NixOS module and run
          # a plain wpa_supplicant against an admin-managed conf at
          # /var/lib/wpa_supplicant/wlan0.conf. /var/lib survives reboot
          # and the file is not in the nix store, so creds stay off git.
          # See docs/chip.md for the conf file format and one-time setup.
          networking.wireless.enable = lib.mkForce false;

          systemd.services.wpa-supplicant-wlan0 = {
            description = "wpa_supplicant on wlan0 (admin-managed conf)";
            wantedBy = [ "multi-user.target" ];
            after = [ "sys-subsystem-net-devices-wlan0.device" ];
            wants = [ "sys-subsystem-net-devices-wlan0.device" ];
            # ConditionPathExists skips the unit (no-op, not failure) until
            # an admin drops the conf. Without this, a fresh sdimage with no
            # conf yet enters a 5s-restart loop that hammers wpa_supplicant
            # scans against nearby APs, accruing auth_failures fast enough
            # to trigger client-side TEMP-DISABLED + AP-side rate-limit.
            unitConfig.ConditionPathExists = "/var/lib/wpa_supplicant/wlan0.conf";
            serviceConfig = {
              Type = "simple";
              Restart = "on-failure";
              RestartSec = 10;
              ExecStart =
                "${pkgs.wpa_supplicant}/bin/wpa_supplicant"
                + " -i wlan0"
                + " -c /var/lib/wpa_supplicant/wlan0.conf"
                + " -D nl80211";
            };
          };

          systemd.tmpfiles.rules = [
            "d /var/lib/wpa_supplicant 0700 root root -"
          ];

          # Bring wlan0 up under systemd-networkd once associated.
          systemd.network.networks."40-wlan0" = {
            matchConfig.Name = "wlan0";
            networkConfig = {
              DHCP = "yes";
              IPv6AcceptRA = true;
            };
          };

          # USB-OTG ethernet gadget. Lets a PC plug into the micro-USB port
          # and ssh to chip at 172.20.7.1 (handy before Wi-Fi associates).
          # `g_ether` is auto-loaded via boot.kernelModules above.
          systemd.network.networks."40-usb0" = {
            matchConfig.Name = "usb0";
            networkConfig = {
              Address = "172.20.7.1/24";
              DHCPServer = true;
            };
            dhcpServerConfig = {
              PoolOffset = 100;
              PoolSize = 20;
            };
          };
        }
      )
    ];
  };
}
