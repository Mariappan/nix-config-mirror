{ pkgs, lib, ... }:
{
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      # default - graphical-session.target
      target = "graphical-session.target";
      environment = [ ];
    };
    extraConfig = builtins.readFile ../../../dotfiles/caelestia/shell.json;
    cli = {
      enable = true;
      extraConfig = builtins.readFile ../../../dotfiles/caelestia/cli.json;
    };
  };

  programs.swappy.enable = true;
  programs.swappy.settings = {
    Default = {
      auto_save = false;
      save_dir = "$XDG_PICTURES_DIR/Screenshots/";
      save_filename_format = "Screenshot-%Y%m%d-%H%M%S.png";
      transparent = false;
    };
  };
}
