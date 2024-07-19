{pkgs, ...}: {
  imports = [
    ./rust.nix
    ./dev.nix
    ./debug.nix
    ./gpgagent.nix
    ./air_dconf.nix
    ./hyprland.nix
  ];

  home.packages = [
    pkgs.google-chrome
    pkgs.slack
    pkgs.obsidian
  ];
}
