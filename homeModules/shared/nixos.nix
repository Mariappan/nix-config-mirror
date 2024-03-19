{ config, pkgs, inputs, ... }:

{
  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = [
    pkgs.wezterm
  ];
}
