{pkgs, ...}: {
  imports = [./wezterm.lua];

  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = [
    pkgs.inetutils
    pkgs.victor-mono
    pkgs.firefox
  ];

  programs.command-not-found.enable = false;
}
