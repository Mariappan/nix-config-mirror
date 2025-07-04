{
  pkgs,
  lib,
  ...
}: {

  nixma.core.enable = true;
  nixma.nixos.enable = true;
  nixma.git.enable = true;
  nixma.xdg.enable = true;
  nixma.jujutsu.enable = true;
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
