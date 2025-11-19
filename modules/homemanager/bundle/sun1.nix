{
  pkgs,
  lib,
  ...
}:
{
  nixma.hm.core.enable = true;
  nixma.hm.moderntools.enable = true;
  nixma.hm.git.enable = true;
  nixma.hm.jujutsu.enable = true;
  nixma.hm.rust.enable = true;
  nixma.hm.dev.enable = true;
  nixma.hm.debug.enable = true;
  nixma.hm.gpgagent.enable = true;

  # Linux-specific configuration
  nixma.hm.linux.dconf.enable = lib.mkIf pkgs.stdenv.isLinux true;
  nixma.hm.linux.nixos.enable = lib.mkIf pkgs.stdenv.isLinux true;
  nixma.hm.linux.xdg.enable = lib.mkIf pkgs.stdenv.isLinux true;
  nixma.hm.linux.niri.enable = lib.mkIf pkgs.stdenv.isLinux true;

  home.packages = lib.mkIf pkgs.stdenv.isLinux [
    pkgs.vivaldi-wayland
    pkgs.claude-code
    pkgs.spotify
    pkgs.spotify-player
  ];
}
