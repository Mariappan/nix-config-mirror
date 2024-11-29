{pkgs, ...}: {
  imports = [
    ./rust.nix
    ./dev.nix
    ./debug.nix
    ./hyprland
  ];

  home.packages = [
    pkgs.google-chrome
    pkgs.obsidian
  ];
}
