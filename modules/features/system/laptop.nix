{
  flake.modules.nixos.laptop =
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
        enable = lib.mkOption {
          type = lib.types.bool;
          default = config.nixma.nixos.formFactor == "laptop";
          description = "Laptop power-management stack (lid switch, upower, fwupd, auto-cpufreq).";
        };

        supportHibernate = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to enable hibernate support. If false, lid switch will only suspend.";
        };
      };

      config = lib.mkIf cfg.enable {
        services.logind.settings.Login.HandleLidSwitch =
          if cfg.supportHibernate then "suspend-then-hibernate" else "suspend";
        services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
        services.logind.settings.Login.HandleLidSwitchDocked = "ignore";

        systemd.sleep.settings.Sleep.HibernateDelaySec = lib.mkIf cfg.supportHibernate "30min";

        services.upower.enable = true;
        # services.power-profiles-daemon.enable = true;

        # Firmware updates via LVFS (BIOS, EC, dock firmware).
        services.fwupd.enable = true;

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
      };
    };
}
