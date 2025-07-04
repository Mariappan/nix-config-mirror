{
  pkgs,
  lib,
  ...
}: {

  nixma.rust.enable = true;
  nixma.dev.enable = true;
  nixma.debug.enable = true;
  nixma.gpgagent.enable = true;
  nixma.hyprland.enable = true;
  nixma.dconf.enable = true;

  home.packages = [
    pkgs.google-chrome
    pkgs.slack
    pkgs.obsidian
    pkgs.remmina
    pkgs.nushell
  ];
}
