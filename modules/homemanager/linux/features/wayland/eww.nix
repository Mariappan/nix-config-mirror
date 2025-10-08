{ pkgs, ... }:
{
  programs.eww.enable = true;
  programs.eww.enableFishIntegration = true;
  # programs.eww.configDir = ../../../../../dotfiles/eww;
}
