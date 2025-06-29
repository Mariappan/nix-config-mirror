{ config, pkgs, inputs, lib, ... }:

{
  xdg.configFile = {
    "quickshell/caelestia" = {
      source = ./shell;
      recursive = true;
    };
  };
}
