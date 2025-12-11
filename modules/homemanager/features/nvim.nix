{
  dotfilesPath,
  ...
}:
{
  programs.neovim = {
    enable = true;
    withPython3 = true;
  };

  xdg.configFile = {
    "nvim" = {
      enable = true;
      source = dotfilesPath + "/nvim";
      target = "nvim";
    };
  };
}
