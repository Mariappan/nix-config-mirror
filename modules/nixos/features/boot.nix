# Configurable boot module for NixOS systems
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixma.nixos.boot;

  # Map kernel package names to actual packages
  kernelPackageMap = {
    "default" = pkgs.linuxPackages;
    "latest" = pkgs.linuxPackages_latest;
    "hardened" = pkgs.linuxPackages_hardened;
    "zen" = pkgs.linuxPackages_zen;
    "lts" = pkgs.linuxPackages;
    "xanmod" = pkgs.linuxPackages_xanmod_latest;
    "xanmod_stable" = pkgs.linuxPackages_xanmod_stable;
  };

  # Determine which kernel package to use
  selectedKernelPackage =
    if cfg.kernelVersion != null then
      # Use specific kernel version if provided (e.g., "6.1" -> linux_6_1)
      let
        versionUnderscore = lib.replaceStrings [ "." ] [ "_" ] cfg.kernelVersion;
        kernelAttr = "linux_${versionUnderscore}";
      in
      pkgs.linuxKernel.packages.${kernelAttr}
        or (throw "Kernel version ${cfg.kernelVersion} not available in pkgs.linuxKernel.packages.${kernelAttr}")
    else
      # Use predefined kernel package
      kernelPackageMap.${cfg.kernelPackage};
in
{
  options.nixma.nixos.boot = {
    kernelPackage = lib.mkOption {
      type = lib.types.enum (builtins.attrNames kernelPackageMap);
      default = "default";
      description = ''
        Kernel package to use. Options:
        - default: Standard NixOS kernel
        - latest: Latest stable kernel
        - hardened: Security-hardened kernel
        - zen: Zen kernel (optimized for desktop)
        - lts: Long-term support kernel
        - xanmod: Xanmod latest kernel
        - xanmod_stable: Xanmod stable kernel

        This option is ignored if kernelVersion is set.
      '';
    };

    kernelVersion = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "6.12";
      description = ''
        Specific kernel version to use (e.g., "6.1", "6.6", "6.12").
        When set, this overrides the kernelPackage option.
        The version should match available packages in pkgs.linuxKernel.packages.
      '';
    };

    kernelParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "ip=dhcp"
        "boot.shell_on_fail"
      ];
      description = "Kernel boot parameters";
    };

    kernelModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of kernel modules to load";
    };

    blacklistedKernelModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of kernel modules to blacklist";
    };

    kernelPatches = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Name of the kernel patch";
          };
          patch = lib.mkOption {
            type = lib.types.path;
            description = "Path to the patch file";
          };
        };
      });
      default = [ ];
      description = "List of kernel patches to apply";
    };

    tmpfs = {
      enable = lib.mkEnableOption "tmpfs for /tmp";

      size = lib.mkOption {
        type = lib.types.str;
        default = "8G";
        description = "Size of tmpfs for /tmp";
      };
    };

    initrd = {
      availableKernelModules = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of available kernel modules in initrd";
      };

      network = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable network in initrd";
        };

        ssh = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable SSH in initrd";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 2022;
            description = "SSH port in initrd";
          };

          hostKeys = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
            description = "SSH host keys for initrd";
          };
        };
      };
    };

    systemdBoot = {
      configurationLimit = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Number of configurations to keep in systemd-boot menu";
      };
    };
  };

  config = {
    # Bootloader
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = cfg.systemdBoot.configurationLimit;

    # Kernel configuration
    boot.kernelPackages = selectedKernelPackage;
    boot.kernelParams = cfg.kernelParams;
    boot.kernelModules = cfg.kernelModules;
    boot.blacklistedKernelModules = cfg.blacklistedKernelModules;
    boot.kernelPatches = cfg.kernelPatches;

    # Tmpfs configuration
    boot.tmp.useTmpfs = cfg.tmpfs.enable;
    boot.tmp.tmpfsSize = lib.mkIf cfg.tmpfs.enable cfg.tmpfs.size;

    # Initrd configuration
    boot.initrd = {
      availableKernelModules = cfg.initrd.availableKernelModules;
      kernelModules = [ ];

      systemd = {
        enable = true;
        users.root.shell = lib.mkIf (config.boot.initrd.systemd.enable) "/bin/systemd-tty-ask-password-agent";
      };

      network = lib.mkIf cfg.initrd.network.enable {
        enable = true;
        ssh = lib.mkIf cfg.initrd.network.ssh.enable {
          enable = true;
          port = cfg.initrd.network.ssh.port;
          authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
          hostKeys = cfg.initrd.network.ssh.hostKeys;
          shell = lib.mkIf (!config.boot.initrd.systemd.enable) "/bin/cryptsetup-askpass";
        };
      };
    };
  };
}
