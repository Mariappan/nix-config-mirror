{ self, ... }:
{
  flake.modules.homeManager.vim =
    { ... }:
    {
      nixma.imported.vim = true;

      home.file = {
        "vim" = {
          enable = true;
          source = self + /dotfiles/vimrc;
          target = ".vimrc";
        };
      };
    };
}
