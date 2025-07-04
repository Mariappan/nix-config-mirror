{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../features/rust.nix
    ../features/dev.nix
    ../features/debug.nix
    ../features/gpgagent.nix
    ../features/hyprland
    ./air_dconf.nix
  ];
  # ++ lib.optionals pkgs.stdenv.isLinux [ ./air_dconf.nix ];

  home.packages = [
    pkgs.google-chrome
    pkgs.slack
    pkgs.obsidian
    pkgs.remmina
    pkgs.nushell
  ];
}
