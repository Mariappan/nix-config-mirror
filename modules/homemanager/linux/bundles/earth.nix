{
  pkgs,
  lib,
  ...
}:
{

  nixma.core.enable = true;
  nixma.git.enable = true;
  nixma.jujutsu.enable = true;
  nixma.debug.enable = true;
  nixma.gpgagent.enable = true;
  nixma.wezterm.enable = true;
  nixma.linux.dconf.enable = true;
  nixma.linux.hyprland.enable = true;
  nixma.linux.caelestia.enable = true;
  nixma.linux.nixos.enable = true;
  nixma.linux.xdg.enable = true;

  home.packages = [
    pkgs.nushell
  ];
}
