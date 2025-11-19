{ pkgs, ... }:
{
  imports = [
    ./wayland.nix
    ./wayland-dm.nix
  ];

  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  # Enable it for debug package
  # programs.hyprland.package = pkgs.hyprland.override {
  #   debug = true;
  # };
  programs.wshowkeys.enable = true;

  xdg.terminal-exec.settings = {
    Hyprland = [
      "com.mitchellh.ghostty"
    ];
  };
}
