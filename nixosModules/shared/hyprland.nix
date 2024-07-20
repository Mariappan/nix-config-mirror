{pkgs, ...}: {
  imports = [./xserver.nix];

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  programs.waybar.enable = true;

  services.logind.powerKey = "ignore";

  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.lidSwitchDocked = "lock";

  environment.systemPackages = [
    pkgs.hyprpicker
    pkgs.swaynotificationcenter
    pkgs.kitty
    pkgs.ianny
    pkgs.swww
    pkgs.wl-clipboard
  ];
}
