{
  config,
  pkgs,
  lib,
  ...
}: {
  xdg.configFile = {
    "nvim" = {
      enable = true;
      source = ../dotfiles/nvim;
      target = "nvim";
    };
  };
}
