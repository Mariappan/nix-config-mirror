# NextThing Co CHIP (Allwinner R8 / sun5i)

Notes for the CHIP host. armv7l Cortex-A8, 512 MiB DDR3, 4 GiB NAND,
SDIO RTL8723BS Wi-Fi/BT combo. No Ethernet. Boots u-boot from NAND,
rootfs from microSD.

## Hardware quirks resolved in `modules/hosts/chip.nix`

- **Cross-compile** from x86_64 (`nixpkgs.buildPlatform.system =
  "x86_64-linux"`) to avoid needing an armv7l builder.
- **Kernel patch**: `CONFIG_RESET_GPIO=n` - kernel 6.18 regression
  rejects 3-cell GPIO providers in the reset framework, which kills
  `mmc-pwrseq-simple` probe and prevents SDIO from coming up. See
  `docs/claude/chip-wifi-reset-gpio-bug.md` for the trace.
- **r8723bs module params**: HT + power-save disabled. Defaults
  advertise 40 MHz / SGI capabilities the 1T1R radio can't honour,
  causing AP-side assoc-rejects (802.11 status 1). 11g (54 Mbps) is
  the max rate after this.
- **avahi seccomp**: `SystemCallFilter` cleared because NixOS' x86_64-
  tuned filter SIGSYS-kills `setgroups` on armv7l.
- **fish disabled**: cross-compile xtask fails (links host pcre2).
  zsh is the login shell instead.
- **u-boot preboot**: `fdt_addr_r` / `ramdisk_addr_r` bumped to dodge
  zImage overlap on modern kernels (sunxi defines these as C macros,
  not Kconfig, so an extraConfig `CONFIG_FDT_ADDR_R=` would no-op -
  use `CONFIG_USE_PREBOOT` instead).

## Boot chain

```
SoC BootROM --> SPL (NAND) --> u-boot (NAND) --> extlinux.conf (SD) -->
                                                       |
                                                       v
                                              kernel + dtb + initrd
                                                       |
                                                       v
                                                  NixOS init
```

u-boot lives in NAND so the board boots without an SD card present
(falls into u-boot shell). With an SD card containing the nixos
sd-image, extlinux picks up the boot entries and NixOS comes up.

## First-boot checklist

1. Flash sd-image: `dd` `result/sd-image/*.img.zst` (xz-decompressed)
   to microSD.
2. Insert SD card, power on. Serial console on UART headers, 115200 8N1.
3. Login as `root` / password `chip` (set in `chip.nix` as
   `initialPassword`).
4. Stage Wi-Fi credentials (see next section). Without them, the only
   reachable interface is `usb0` at `172.20.7.1` via micro-USB OTG.

## Adding a Wi-Fi network

CHIP uses a plain `wpa_supplicant` running against a chip-local config
at `/var/lib/wpa_supplicant/wlan0.conf` (not in the nix store, not in
git). Edit that file on the device.

### One-time setup (or whenever the SD is reflashed)

```sh
# either ssh in over USB-OTG ethernet (172.20.7.1) or use serial console
sudo mkdir -p /var/lib/wpa_supplicant
sudo install -m 600 /dev/null /var/lib/wpa_supplicant/wlan0.conf
sudo $EDITOR /var/lib/wpa_supplicant/wlan0.conf
```

Minimal WPA2-PSK content:

```
ctrl_interface=/run/wpa_supplicant
update_config=1
country=SG

network={
    ssid="MY_SSID"
    psk="MY_PSK"
    key_mgmt=WPA-PSK
}
```

Then start the unit:

```sh
sudo systemctl start wpa-supplicant-wlan0
sudo systemctl status wpa-supplicant-wlan0
```

`networking.wireless.enable` is forced `false` in `chip.nix`, so the
NixOS-generated `wpa_supplicant.service` is not running. The custom
unit `wpa-supplicant-wlan0.service` takes its place.

The unit has `ConditionPathExists=/var/lib/wpa_supplicant/wlan0.conf`,
so it stays inactive (clean, not failed) on a fresh image until you
drop the conf. Once the conf exists, `systemctl start` (or a reboot)
lights it up. Without that guard, the default 5s-restart loop on a
missing conf rapidly accrues `auth_failures` against nearby APs and
can trip AP-side rate limits that block the chip MAC temporarily.

### Switching networks at runtime

Edit `/var/lib/wpa_supplicant/wlan0.conf`, then:

```sh
sudo systemctl restart wpa-supplicant-wlan0
```

Multiple networks in the same conf:

```
network={
    ssid="Home"
    psk="..."
    key_mgmt=WPA-PSK
    priority=10
}

network={
    ssid="Phone-Hotspot"
    psk="..."
    key_mgmt=WPA-PSK
    priority=5
}
```

Higher `priority` wins when both are in range.

### Hashing the PSK (avoid plaintext)

If you'd rather not store the plaintext PSK in `wlan0.conf`:

```sh
wpa_passphrase 'MY_SSID' 'MY_PSK'
```

Take the `psk=<hex>` line and substitute it for the `psk="..."` form.
Functionally identical; the hex is the PBKDF2(ssid, passphrase) hash.

### IP comes from networkd

`systemd-networkd` is configured to DHCP `wlan0` (see `40-wlan0` in
`chip.nix`). No separate `dhcpcd` invocation needed.

## USB-OTG ethernet gadget

`g_ether` is auto-loaded. Plug the micro-USB into a PC; the PC sees a
new ethernet (`usb0` on Linux, "RNDIS" on Windows). CHIP serves DHCP
at `172.20.7.1`. PC gets `172.20.7.100`+ from the pool.

Useful for serial-less access during initial setup.

## Build pinning

CHIP closures get GC'd quickly because nothing on the dev box runs
them. `scripts/chip-pin-deps` anchors every store path in the chip
closure as a gcroot under `~/.local/share/nix-roots/chip/`.

Run after each successful build:

```sh
just chip-pin-deps
```

## Deploy

Cross-compile + push closure + activate:

```sh
nixos-rebuild switch --flake .#chip \
  --target-host hl-chipifi \
  --use-substitutes --sudo --ask-sudo-password
```

After activation, if r8723bs module params changed, reload:

```sh
ssh hl-chipifi 'sudo rmmod r8723bs && sudo modprobe r8723bs'
```

Kernel changes (e.g. `boot.kernelPatches`) only take effect on reboot.

## No agenix on chip (by design)

chip has no entries in `age.secrets.*` and is not a recipient in
`secrets/secrets.nix`. On a fresh sd-image the host's ssh ed25519 key
is generated by `sshd-keygen.target` *after* the activation script
runs, so any agenix-managed secret would chicken-egg on first boot
("no readable identities found"). The wifi conf in `/var/lib/`
sidesteps that entirely; if you need a real secret on chip later,
migrate to agenix-rekey (sdcard-pre-staged host key) rather than
adding chip back to `secrets/secrets.nix`.
