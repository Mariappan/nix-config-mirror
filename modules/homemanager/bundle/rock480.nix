{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  nixma.hm.desktop.enable = true;
  nixma.hm.moderntools.enable = true;
  nixma.hm.git.enable = true;
  nixma.hm.jujutsu.enable = true;
  nixma.hm.dev.enable = true;
  nixma.hm.debug.enable = true;
  nixma.hm.zen-browser.enable = true;

  # Linux-specific configuration
  nixma.hm.linux.hyprland.enable = lib.mkIf pkgs.stdenv.isLinux true;
  nixma.hm.linux.caelestia.enable = true;

  home.packages = lib.mkIf pkgs.stdenv.isLinux [
    pkgs.pavucontrol
    pkgs.nixma.treewalker
  ];
}
