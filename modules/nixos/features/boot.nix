# Configurable boot module for NixOS systems
{
  config,
  lib,
  ...
}:
let
  cfg = config.nixma.nixos.boot;
in
{
  options.nixma.nixos.boot = {
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
    boot.kernelParams = cfg.kernelParams;
    boot.kernelModules = cfg.kernelModules;
    boot.blacklistedKernelModules = cfg.blacklistedKernelModules;

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
