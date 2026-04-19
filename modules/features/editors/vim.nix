{ self, ... }:
{
  flake.modules.homeManager.vim = { ... }: {
    home.file = {
      "vim" = {
        enable = true;
        source = self + /dotfiles/vimrc;
        target = ".vimrc";
      };
    };
  };
}
