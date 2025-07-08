{
  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.lidSwitchDocked = "ignore";

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}
