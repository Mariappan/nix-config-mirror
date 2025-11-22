{ pkgs, ... }:
{
  # Shared shell configuration across NixOS and Darwin
  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment.shells = [
    pkgs.bashInteractive
    pkgs.zsh
    pkgs.fish
  ];
}
