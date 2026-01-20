{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixma.nixos.bluetooth;
in
{
  options.nixma.nixos.bluetooth = {
    reloadDriverAfterHibernate = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Reload btintel_pcie driver after hibernation to fix suspend issues (kernel 6.18+)";
    };
  };

  config = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          # Shows battery charge of connected devices on supported devices
          Experimental = true;
          FastConnectable = false; # increased power consumption on true
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    # Workaround for btintel_pcie failing to suspend after hibernation (kernel 6.18+)
    # The Intel Bluetooth PCIe driver gets stuck after hibernation and blocks suspend.
    systemd.services.bluetooth-post-hibernate = lib.mkIf cfg.reloadDriverAfterHibernate {
      description = "Reload Bluetooth driver after hibernation";
      after = [
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
      wantedBy = [
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.kmod}/bin/modprobe -r btintel_pcie";
        ExecStartPost = "${pkgs.kmod}/bin/modprobe btintel_pcie";
      };
    };
  };
}
