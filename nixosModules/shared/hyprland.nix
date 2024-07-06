{pkgs, ...}: {
  imports = [./xserver.nix];

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  programs.waybar.enable = true;

  environment.systemPackages = [
    pkgs.wl-clipboard
    pkgs.kitty
  ];
}
