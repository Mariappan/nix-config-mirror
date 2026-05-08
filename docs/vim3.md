# Khadas VIM3 (A311D, V12)

Notes from the debug session that brought the board up as an aarch64-linux
NixOS host and remote builder. Capture the things that aren't obvious from
the upstream NixOS or Khadas docs in isolation.

## Hardware summary

| Part | Detail |
|---|---|
| SoC | Amlogic g12b A311D — 4× Cortex-A53 + 2× Cortex-A73, 6 cores total |
| RAM | 4 GiB LPDDR4 (3.7 GiB usable) |
| eMMC | Samsung BJTD4 (manfid 0x15), 29.1 GiB, MMC 5.1, 8-bit |
| SPI | 16 MiB SPI-NOR flash, used for the boot bootloader |
| MCU | STMicro ST008 — handles power, blue LED, KBI flags, WOL keep-alive |
| RTC | hym8563 (no backup battery on this board) |
| Eth | gigabit, dwmac + RTL8211F PHY (`end0`) |
| WiFi | BCM4359 SDIO (no firmware in nixpkgs `linux-firmware`) — wired only |
| HW ver | VIM3.V12 (read via `kbi hwver`) |
| MCU fw | 0.02 (read via `kbi version`) |

The MCU firmware version matters: 0.02 is too old to honour `kbi bootmode`
across true power cycles, but the WOL keep-alive flag (`kbi trigger wol w 1`)
is honoured and persists across reflashes of u-boot.

## Boot chain

```
SoC BootROM (mask ROM) ──► SPI? ──► eMMC? ──► SD? ──► USB
                                │       │       │
                                ▼       ▼       ▼
                             OOWOW    BL2+FIP+u-boot    fallback
                              (SPI)        (boot0/1)
                                              │
                                              ▼
                                  /boot/extlinux/extlinux.conf
                                              │
                                              ▼
                                   kernel + initrd + dtb
                                              │
                                              ▼
                                          NixOS init
```

Boot priority is set by the POC (Power-On-Config) bits, which the on-board
MCU drives at reset. `kbi bootmode w spi|emmc` flips the MCU flag; with MCU
firmware 0.02 the change does not always survive a cold power-cut, so don't
rely on it for permanence — leave it at `emmc` and put the bootloader you
want at `mmc 1 part 1` (eMMC `boot0`).

## eMMC layout the BootROM cares about

`/dev/mmcblk1` enumerates as **mmc 1** in u-boot:

| Partition | Path | Use |
|---|---|---|
| `0` (user area) | `/dev/mmcblk1` | GPT + FAT `/boot` + ext4 `/` (managed by disko) |
| `1` (boot0, 4 MiB hw) | `/dev/mmcblk1boot0` | **u-boot lives here** (BootROM reads sector 1 byte 16 for the `@AML` magic) |
| `2` (boot1, 4 MiB hw) | `/dev/mmcblk1boot1` | redundant copy of u-boot |

A common dead end: writing the new u-boot to the user area at sector 1
following the `write_uboot_platform` recipe in Khadas's `platform_install.sh`
appears to succeed, but on this board the disko GPT lives there and the
write either lands in GPT or is ignored by the BootROM. **The u-boot the
BootROM actually loads on VIM3 lives in `boot0`.** Verify by reading the
first 32 bytes of sector 1 of each device — `boot0` shows the
`EN9.+E.o/...@AML` Amlogic header, the user-area shows `EFI PART`.

## SPI flash and OOWOW

The SPI is a 16 MiB W25Q128 (`/dev/mtd0` if exposed). Khadas ships
[OOWOW](https://docs.khadas.com/software/oowow/how-to/start) as a tiny
buildroot Linux + u-boot blob that lives in SPI for recovery / reflash.
OOWOW's u-boot is also mainline-based (currently u-boot 2021.07 / khadas-uboot
0.17.x) and is the safest fallback when the eMMC bootloader is bad — boot
the OOWOW SD image (or hold POWER while plugging USB-C if OOWOW is in SPI)
and use its menu / shell.

OOWOW source: <https://dl.khadas.com/products/vim3/firmware/oowow/>
(`vim3-oowow-latest-sd.img.gz`).

OOWOW from SPI **does not** auto-chain to an installed OS — it always shows
its menu first. The factory-shipped MCU does not yet know about WOL keep-alive,
so a `poweroff` from OOWOW also kills PHY power, defeating WOL.

## Two u-boots, two trade-offs

Both binaries are signed FIP images for the A311D. Pick based on what you
need; you can swap freely.

| | vendor 2015.01 (`linux-u-boot-vim3-vendor` deb) | khadas-uboot 0.17.x (mainline + Khadas patches) |
|---|---|---|
| Source | <https://dl.khadas.com/repos/debs/vim3/> | <https://github.com/khadas/khadas-uboot/releases> |
| Filename | `u-boot.bin` (1.33 MiB), no MBR | `VIM3.u-boot.sd.bin` (1.36 MiB), MBR + body |
| Prompt | `kvim3#` | `=>` |
| `kbi trigger wol w 1` | ✅ — persists in MCU after power-cut | ❌ removed from KBI subset |
| extlinux / `distro_bootcmd` | ❌ legacy `cfgload` only (looks for `boot.ini`) | ✅ scans `/extlinux/extlinux.conf` |
| Boots NixOS as-shipped | ❌ NixOS extlinux paths are too long for `cfgload` LFN | ✅ |
| Networking from u-boot | ❌ broken — DHCP/ARP fails despite 1G PHY link | ✅ DHCP + TFTP work |
| USB mass storage in u-boot | ✅ `usb start; fatload usb 0` | ✅ |

Practical recipe: boot the vendor build once via USB, run `kbi trigger wol w 1`
to set the MCU flag, then flash the mainline build back so NixOS boots.
The MCU keeps the WOL flag through the swap.

## Recovery — flash u-boot from the u-boot prompt

The eMMC user area stops being usable for u-boot once disko writes the GPT,
so any reflash must target `boot0` and `boot1` directly. Two transports work
in u-boot itself; a third path is a Linux shell from OOWOW.

### USB stick (works on either u-boot variant)

Most reliable, especially with vendor 2015.01 whose dwmac driver can't get
DHCP/ARP working. FAT32 stick, image dropped at `vim3/<file>`:

```
usb start
fatload usb 0 0x1080000 vim3/VIM3.u-boot.sd.bin

mmc dev 1 1
mmc write 0x1080000 0 0xa70

mmc dev 1 2
mmc write 0x1080000 0 0xa70

mmc dev 1 0
reset
```

`0xa70` blocks = 1.37 MiB which covers both binary variants.

### TFTP (mainline u-boot only — vendor's networking is broken)

```
setenv ipaddr   10.89.20.51
setenv netmask  255.255.255.0
setenv gatewayip 10.89.20.1
setenv serverip 10.89.20.10

tftp 0x1080000 VIM3.u-boot.sd.bin
mmc dev 1 1; mmc write 0x1080000 0 0xa70
mmc dev 1 2; mmc write 0x1080000 0 0xa70
mmc dev 1 0
reset
```

Set up a tftpd-hpa (or dnsmasq with `--enable-tftp`) on a same-VLAN host —
TFTP doesn't traverse VLANs cleanly.

### From OOWOW Linux shell (last resort)

Boot OOWOW from SD, drop to its shell, fetch the binary (HTTP works), then:

```
# disable MMC boot-area write protection, write, re-enable
echo 0 > /sys/block/mmcblk1boot0/force_ro
dd if=u-boot.bin of=/dev/mmcblk1boot0 bs=1 seek=512 conv=fsync
echo 1 > /sys/block/mmcblk1boot0/force_ro

echo 0 > /sys/block/mmcblk1boot1/force_ro
dd if=u-boot.bin of=/dev/mmcblk1boot1 bs=1 seek=512 conv=fsync
echo 1 > /sys/block/mmcblk1boot1/force_ro
sync
```

This is the path the deb's `write_uboot_platform_ext` shell function uses;
it expects the raw `u-boot.bin` (no MBR), seeking to byte 512 so the `@AML`
magic at byte 16 of the file lands at `boot0` byte 528 (sector 1 byte 16).

## Wake-on-LAN

Three layers must align:

1. **Linux ethtool** — `ethtool -s end0 wol g`. NixOS does this automatically
   via `networking.interfaces.end0.wakeOnLan.enable = true`.
2. **MCU flag** — `kbi trigger wol w 1` from vendor u-boot. Without this the
   MCU cuts the 3.3 V rail to the PHY at `poweroff`, so the magic packet
   never reaches the NIC. Persists across u-boot swaps.
3. **L2 reach** — magic packets are link-local broadcasts. Send from the
   same VLAN as `end0`, or use OPNsense's *Services → Wake on LAN* form
   which proxies into the right L2.

Verify after boot:

```
ethtool end0 | grep Wake-on   # expect: Wake-on: g
```

Then test:

```
ssh hl-vim3 sudo poweroff      # ethernet jack LED should stay on
# from a host on the same VLAN:
wakeonlan c8:63:14:70:46:be
```

If LED goes dark on poweroff, step 2 didn't take — flash vendor u-boot,
re-run `kbi trigger wol w 1`, flash mainline back.

## NixOS image build, flash, growpart

The host module at `modules/hosts/vim3.nix` configures disko to build a 4 GiB
GPT image with FAT `/boot` (16 MiB offset to leave room for the bootloader
the BootROM reads from `boot0`/`boot1`) and ext4 `/`. Build via the vim3
remote builder (it can build for itself), or any aarch64 substituter:

```
nix build .#nixosConfigurations.vim3.config.system.build.diskoImages \
  --no-link --print-out-paths --max-jobs 0 -L
# → /nix/store/<hash>-vim3-disko-images/main.raw
```

KVM accel matters — without `extra-sandbox-paths = /dev/kvm` and `kvm` in
`system-features` (and `chmod 0666 /dev/kvm` so the nixbld sandbox can open
it across the dropped supplementary groups) the disko-image VM falls to TCG
and the build is ~10× slower.

Flash to eMMC user area. **dd directly on the device — do not stream over
SSH** (that earlier produced a 24 KiB-overshoot corrupt image where the
FAT directory blocks for `/nixos/<hash>-dtbs/` returned garbage and the
extlinux FDT load failed). scp the image to the running NixOS first, then:

```
sudo dd if=main.raw of=/dev/mmcblk1 bs=1M oflag=direct conv=fsync \
  status=progress
sync
```

`boot.growPartition = true` + `fileSystems."/".autoResize = true` then expand
the root partition over the whole eMMC on first boot.

## eMMC wear and RAM mitigations

The board has 3.7 GiB RAM, no swap, and TLC eMMC — a single `nix shell` on
something heavy (e.g. nixpkgs flake) was enough to trigger a hard hang on
the original USB-C PSU (CPU briefly hit ~600 % across 6 cores; brownout =
silent freeze). With a real PD charger the same workload finishes cleanly.
Beyond the PSU, `vim3.nix` enables:

```nix
zramSwap.enable = true;
zramSwap.algorithm = "zstd";
zramSwap.memoryPercent = 75;

nixma.nixos.boot.tmpfs = {
  enable = true;
  size = "2G";
};

fileSystems."/".options     = [ "noatime" ];
fileSystems."/boot".options = [ "noatime" ];

hardware.deviceTree.filter = "meson-g12b-a311d-khadas-vim3*.dtb";
```

The dtb filter shrinks `/boot/nixos/<hash>-dtbs/` from ~129 MiB to ~240 KiB
by dropping every dtb that isn't a VIM3 variant; this also dodges the
LFN-iteration corruption some Khadas u-boots hit on the full upstream dtbs
tree.

`programs.nh.clean` (set repo-wide in `modules/base/nix-settings.nix`) handles
generation cleanup; do not also enable `nix.gc.automatic` on this host.

## Builder role

VIM3 is registered as an aarch64 build machine on `air`
(`modules/hosts/air.nix → nixma.nixos.remoteBuilders.machines.vim3`). For
KVM-accelerated builds:

```
# /etc/nix/nix.custom.conf on the builder
trusted-users        = root @sudo
extra-sandbox-paths  = /dev/kvm
system-features      = nixos-test benchmark big-parallel kvm
```

```bash
# put nixbld* in kvm group, plus relax /dev/kvm
for i in $(seq 1 32); do gpasswd -a "nixbld$i" kvm; done
chmod 0666 /dev/kvm   # plus a udev rule for persistence
```

Set `MODE="0666"` in `/etc/udev/rules.d/99-kvm.rules` so the relaxed mode
survives reboot — supplementary groups are dropped inside the Nix build
sandbox, so `chmod` is the only path that reliably gets `/dev/kvm` open
inside the sandbox.

## Deploying changes to vim3

Build on vim3, deploy locally, sudo as `maari` (NOPASSWD wheel):

```
sudo nixos-rebuild --flake .#vim3 \
  --build-host vim3.local --target-host vim3.local \
  --sudo switch
```

Resolves `vim3.local` via mDNS. If running from another user via `sudo`
where the SSH config lives in `~maari/.ssh/`, add a `Host vim3.local` block
to `/root/.ssh/config` pointing at `/root/.ssh/id_ed25519_nixbuilder` (the
key that was added to vim3's `authorized_keys` for the remote-builder ssh).

## Reference

- KBI commands and meanings: <https://docs.khadas.com/products/sbc/vim3/development/kbi>
- Khadas WOL setup: <https://docs.khadas.com/products/sbc/common/configurations/wol>
- u-boot for VIM3 (mainline): <https://docs.u-boot.org/en/latest/board/amlogic/khadas-vim3.html>
- OOWOW how-to: <https://docs.khadas.com/software/oowow/how-to/start>
- TST mode entry (Function key x3 within 2 s of power-on for Maskrom):
  <https://docs.khadas.com/products/sbc/vim3/install-os/boot-into-upgrade-mode>
