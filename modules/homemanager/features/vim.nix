{
  pkgs,
  self,
  ...
}:
{
  home.file = {
    "vim" = {
      enable = true;
      source = self + /dotfiles/vimrc;
      target = ".vimrc";
    };
  };
}
