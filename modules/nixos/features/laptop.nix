{ ... }:
{
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  services.logind.settings.Login.HandleLidSwitchDocked = "ignore";

  systemd.sleep.extraConfig = ''
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
}
