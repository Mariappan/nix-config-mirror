{pkgs, ...}: {
  imports = [
    ./rust.nix
    ./dev.nix
    ./debug.nix
    ./gpgagent.nix
    ./air_dconf.nix
    ./hyprland_anyrun.nix
  ];

  home.packages = [
    pkgs.google-chrome
    pkgs.slack
    pkgs.obsidian
  ];
}
