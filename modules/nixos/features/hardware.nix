# Configurable hardware module for NixOS systems
{
  config,
  lib,
  modulesPath,
  ...
}:
let
  cfg = config.nixma.nixos.hardware;
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  options.nixma.nixos.hardware = {
    luks = {
      enable = lib.mkEnableOption "LUKS encryption for root and work partitions";

      bypassWorkqueues = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable bypassWorkqueues for better SSD performance";
      };
    };

    work = {
      enable = lib.mkEnableOption "separate /work partition";

      partitionLabel = lib.mkOption {
        type = lib.types.str;
        default = "WORK";
        description = "Partition label for work filesystem";
      };
    };

    swap = {
      enable = lib.mkEnableOption "swap partition";

      partitionLabel = lib.mkOption {
        type = lib.types.str;
        default = "NIXSWAP";
        description = "Partition label for swap";
      };

      randomEncryption = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable random encryption for swap";
      };
    };

    partitions = {
      root = lib.mkOption {
        type = lib.types.str;
        default = "NIXROOT";
        description = "Partition label for root filesystem";
      };

      boot = lib.mkOption {
        type = lib.types.str;
        default = "NIXBOOT";
        description = "Partition label for boot filesystem";
      };
    };

    cpu = {
      vendor = lib.mkOption {
        type = lib.types.enum [
          "intel"
          "amd"
        ];
        description = "CPU vendor for microcode updates";
      };
    };

    hostPlatform = lib.mkOption {
      type = lib.types.str;
      default = "x86_64-linux";
      description = "System platform architecture";
    };
  };

  config = {
    # LUKS configuration (only if enabled)
    boot.initrd.luks.devices = lib.mkIf cfg.luks.enable {
      cryptroot = {
        device = "/dev/disk/by-partlabel/${cfg.partitions.root}";
        bypassWorkqueues = cfg.luks.bypassWorkqueues;
      };
      cryptwork = lib.mkIf cfg.work.enable {
        device = "/dev/disk/by-partlabel/${cfg.work.partitionLabel}";
        bypassWorkqueues = cfg.luks.bypassWorkqueues;
      };
    };

    # Root filesystem - depends on LUKS setting
    fileSystems."/" = {
      device =
        if cfg.luks.enable then
          "/dev/mapper/cryptroot"
        else
          "/dev/disk/by-partlabel/${cfg.partitions.root}";
      fsType = "ext4";
    };

    # Work filesystem - optional
    fileSystems."/work" = lib.mkIf cfg.work.enable {
      device =
        if cfg.luks.enable then
          "/dev/mapper/cryptwork"
        else
          "/dev/disk/by-partlabel/${cfg.work.partitionLabel}";
      fsType = "ext4";
    };

    # Boot filesystem
    fileSystems."/boot" = {
      device = "/dev/disk/by-partlabel/${cfg.partitions.boot}";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    # Swap device - optional
    swapDevices = lib.optionals cfg.swap.enable [
      (
        {
          device = "/dev/disk/by-partlabel/${cfg.swap.partitionLabel}";
        }
        // lib.optionalAttrs cfg.swap.randomEncryption {
          randomEncryption.enable = true;
        }
      )
    ];

    # Enable fstrim for SSD
    services.fstrim.enable = true;

    # Thunderbolt manager daemon boltctl
    services.hardware.bolt.enable = true;

    # Platform
    nixpkgs.hostPlatform = lib.mkDefault cfg.hostPlatform;

    # CPU microcode
    hardware.cpu.intel.updateMicrocode = lib.mkIf (cfg.cpu.vendor == "intel") (
      lib.mkDefault config.hardware.enableRedistributableFirmware
    );
    hardware.cpu.amd.updateMicrocode = lib.mkIf (cfg.cpu.vendor == "amd") (
      lib.mkDefault config.hardware.enableRedistributableFirmware
    );
  };
}
