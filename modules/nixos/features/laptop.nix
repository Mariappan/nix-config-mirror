{
  config,
  lib,
  ...
}:
let
  cfg = config.nixma.nixos.laptop;
in
{
  options.nixma.nixos.laptop = {
    supportHibernate = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable hibernate support. If false, lid switch will only suspend.";
    };
  };

  config = {
    services.logind.settings.Login.HandleLidSwitch =
      if cfg.supportHibernate then "suspend-then-hibernate" else "suspend";
    services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
    services.logind.settings.Login.HandleLidSwitchDocked = "ignore";

    systemd.sleep.extraConfig = lib.mkIf cfg.supportHibernate ''
      HibernateDelaySec=30min
    '';

    services.upower.enable = true;
    # services.power-profiles-daemon.enable = true;

    services.auto-cpufreq.enable = true;
    services.auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        turbo = "always";
        # default performance balance_performance balance_power power
        energy_performance_preference = "balance_power";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };

    # powerManagement.enable = true;
    # powerManagement.powertop.enable = true;
  };
}
