{
  dotfilesPath,
  ...
}:
{
  home.file = {
    "cargo" = {
      enable = true;
      source = dotfilesPath + "/cargo_config.toml";
      target = ".cargo/config.toml";
    };
  };
}
