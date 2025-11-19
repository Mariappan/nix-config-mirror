{
  pkgs,
  self,
  ...
}:
{
  home.file = {
    "cargo" = {
      enable = true;
      source = self + /dotfiles/cargo_config.toml;
      target = ".cargo/config.toml";
    };
  };
}
