# nix-config
Maari's system nix flake

## Description
Collection of nixos and nix-darwin flakes supporting multiple hosts.

## Features
- Flake as default
- Home-manager for users
- Lanzaboote for secureboot
- TPM2 for auto unlock

## Visuals
Later...

## Installation Steps

1. Install dependencies

   ```shell
   sudo -i
   nix-env -iA nixos.git nixos.sbctl
   ```

1. Wipe all filesystem and create GPT drive:

   ```shell
   wipefs -a /dev/nvme0n1
   parted /dev/nvme0n1 -- mklabel gpt
   ```

1. Create the boot partition at the beginning of the disk

   ```shell
   parted /dev/nvme0n1 -- mkpart NIXBOOT fat32 1MiB 1GiB
   parted /dev/nvme0n1 -- set 1 esp on
   ```

1. Create primary partition

   > With LUKS:
   ```shell
   parted /dev/nvme0n1 -- mkpart NIXSWAP linux-swap 1GiB 33GiB
   parted /dev/nvme0n1 -- mkpart NIXROOT EXT4 33GiB 60%
   parted /dev/nvme0n1 -- mkpart WORK EXT4 60% 100%
   ```

   > Without LUKS and SWAP:
   ```shell
   parted /dev/nvme0n1 -- mkpart NIXROOT EXT4 1GiB 100%
   ```

1. Format disk with LUKS 2:

   ```shell
   # format the partition with the luks structure
   cryptsetup luksFormat /dev/disk/by-partlabel/NIXROOT
   # open the encrypted partition and map it to /dev/mapper/cryptroot
   cryptsetup luksOpen /dev/disk/by-partlabel/NIXROOT cryptroot

   cryptsetup luksFormat /dev/disk/by-partlabel/WORK
   cryptsetup luksOpen /dev/disk/by-partlabel/WORK cryptwork
   ```

1. Format disks with filesystem:

   > With LUKS:
   ```shell
   mkfs.fat -F 32 -n NIXBOOT /dev/disk/by-partlabel/NIXBOOT
   mkswap -L NIXSWAP /dev/disk/by-partlabel/NIXSWAP

   mkfs.ext4 -L NIXROOT /dev/mapper/cryptroot
   mkfs.ext4 -L WORK /dev/mapper/cryptwork
   ```

   > Without LUKS:
   ```shell
   mkfs.fat -F 32 -n NIXBOOT /dev/disk/by-partlabel/NIXBOOT
   mkfs.ext4 -L NIXROOT /dev/disk/by-partlabel/NIXROOT
   ```

1. Check the partitions:

   ```shell
   lsblk
   lsblk --fs
   blkid
   ```

1. Mount partitions

   ```shell
   # mount
   mount /dev/disk/by-label/NIXROOT /mnt
   mkdir /mnt/boot -p
   mount /dev/disk/by-label/NIXBOOT /mnt/boot

   # If required:
   swapon /dev/disk/by-label/NIXSWAP
   ```

1. Generate nixos config

   ```
   nixos-generate-config --root /mnt
   ```

1. Make backup and pull nix-config from git and compare hardware_configuration and boot.nix:

   ```shell
   mv /mnt/etc/nixos /mnt/etc/nixos_generated
   git clone https://gitlab.com/mariappan/nix-config.git /mnt/etc/nixos
   ```

1. Create initrd ssh key:

   ```shell
   mkdir -p /etc/secrets/initrd
   mkdir -p /mnt/etc/secrets/initrd
   ssh-keygen -t ed25519 -N "" -f /mnt/etc/secrets/initrd/ssh_host_ed25519_key
   cp /mnt/etc/secrets/initrd/* /etc/secrets/initrd/
   ```

1. Manage lanzaboote files:

   ```shell
   sbctl create-keys
   # cp -rf /etc/secureboot /mnt/etc/secureboot
   cp -rf /etc/secureboot /mnt/var/lib/sbctl
   cp -rf /var/lib/sbctl /mnt/var/lib/sbctl
   ```

1. Install nixos

   ```shell
   cd /mnt
   nixos-install --impure --flake ./etc/nixos#<hostname>

   # Verify lanzaboote signing
   sbctl verify
   ```

1. Set up user password

   ```
   passwd maari
   ```

## Steps for enabling SecureBoot/TPM2 based LUKS:

1. Install first with secure boot disabled
1. After installing use password to open LUKS disk
1. Enable secure-boot setup mode/Audit mode and enroll keys to secure boot
   - `sudo sbctl enroll-keys`
   - `sudo sbctl enroll-keys --microsoft` - If you want microsoft keys to be installed alongside
1. Reboot
1. After successful boot with secure-boot enabled, enroll TPM2 to cryptenroll
   [Linux TPM PCR Regsitry](https://uapi-group.org/specifications/specs/linux_tpm_pcr_registry/)

```shell
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+12 \
    --wipe-slot=tpm2 /dev/disk/by-partlabel/NIXROOT

sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+12 \
    --wipe-slot=tpm2 /dev/disk/by-partlabel/WORK
```

>>> [!note] PCRs
- PCR 0: Core system firmware executable code
- PCR 2: Extended or pluggable executable code
- PCR 7: SecureBoot state
- PCR 12: Kernel command line, system credentials and system configuration images
>>>

## Tips

1. Use `nh` for updating NixOs
   ```shell
   cd /etc/nixos/
   nh os switch . -- --accept-flake-config
   ```

1. After installing NixOs, run this command to make `nix-index`'s `common-not-found` use the flake recommendation
   ```bash
   nix profile install nixpkgs#hello
   ```

## Just Commands

This project uses [just](https://github.com/casey/just) as a command runner for common tasks.

### Available Commands

#### NixOS (Linux)

```bash
# Update flake inputs
just update [flake]

# Test configuration (activate without updating bootloader)
just test [flake]

# Verify changes (build and show diff)
just verify [flake]

# Build and switch (updates bootloader)
just build [flake]

# Evaluate any configuration parameter for air host
just eval-air <parameter>
```

#### Darwin (macOS)

```bash
# Update flake inputs
just update [flake]

# Test configuration (activate)
just test [flake]

# Build and switch
just build [flake]
```

### Usage Examples

```bash
# Update all flake inputs
just update

# Test configuration changes without updating bootloader
just test

# Build and show what will change
just verify

# Apply changes and update bootloader
just build

# Evaluate specific configuration options for air host
just eval-air boot.initrd.kernelModules
just eval-air networking.hostName
just eval-air hardware.graphics.enable
just eval-air system.stateVersion
```

## ToDo
- Integrate sops-nix

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

- QuickShell config - https://github.com/TLSingh1/dotfiles/tree/main/modules/wm/quickshell

## License
[WTFPL](https://spdx.org/licenses/WTFPL.html)

