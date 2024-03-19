{ config, pkgs, lib, ...}: {

  home.file = {
    "cargo" = {
      enable = true;
      source = ../dotfiles/cargo_config.toml;
      target = ".cargo/config.toml";
    };
    "earthly" = {
      enable = true;
      source = ../dotfiles/earthly_config.yml;
      target = ".earthly/config.yml";
    };
  };

}
