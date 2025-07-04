{
  inputs,
  pkgs,
  lib,
  ...
}: {
  import = [] ++ lib.optionals pkgs.stdenv.isLinux [ ./air_dconf.nix ];

  home.packages = [
    pkgs.google-chrome
    pkgs.slack
    pkgs.obsidian
    pkgs.remmina
    pkgs.nushell
  ];

  nixma.rust.enable = true;
  nixma.dev.enable = true;
  nixma.debug.enable = true;
  nixma.gpgagent.enable = true;
  nixma.hyprland.enable = true;
}
