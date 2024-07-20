{pkgs, ...}: {
  imports = [./xserver.nix];

  programs.hyprland.enable = true;
  programs.wshowkeys.enable = true;

  services.logind.powerKey = "ignore";

  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.lidSwitchDocked = "lock";
}
