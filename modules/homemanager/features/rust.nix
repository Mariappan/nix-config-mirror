{ pkgs, ... }:
{
  home.file = {
    "cargo" = {
      enable = true;
      source = ../../../dotfiles/cargo_config.toml;
      target = ".cargo/config.toml";
    };
  };
}
