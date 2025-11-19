{ pkgs, ... }:
{
  home.file = {
    "vim" = {
      enable = true;
      source = ../../../dotfiles/vimrc;
      target = ".vimrc";
    };
  };
}
