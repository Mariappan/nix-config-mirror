{
  pkgs,
  dotfilesPath,
  ...
}:
{
  home.file = {
    "vim" = {
      enable = true;
      source = dotfilesPath + "/vimrc";
      target = ".vimrc";
    };
  };
}
