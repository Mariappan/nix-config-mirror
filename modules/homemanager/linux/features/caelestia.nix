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
    extraConfig = builtins.readFile ../../../../dotfiles/caelestia/shell.json;
    cli = {
      enable = true;
      extraConfig = builtins.readFile ../../../../dotfiles/caelestia/cli.json;
    };
  };

  # home.activation = {
  #   caelestiaAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #     run cp ${../../../../dotfiles/caelestia/goku.gif} ~/.face.gif
  #   '';
  # };
}
