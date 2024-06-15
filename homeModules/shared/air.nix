{pkgs, ...}: {
  imports = [
    ./rust.nix
    ./dev.nix
    ./debug.nix
    ./gpgagent.nix
  ];

  home.packages = [
    pkgs.google-chrome
    pkgs.slack
    pkgs.obsidian
  ];
}
