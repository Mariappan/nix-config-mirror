{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  nixma.hm.desktop.enable = true;
  nixma.hm.moderntools.enable = true;
  nixma.hm.git.enable = true;
  nixma.hm.jujutsu.enable = true;
  nixma.hm.rust.enable = true;
  nixma.hm.dev.enable = true;
  nixma.hm.debug.enable = true;
  nixma.hm.gpgagent.enable = true;
  nixma.hm.earthly.enable = true;
  nixma.hm.zen-browser.enable = true;
  nixma.hm.vivaldi.enable = true;

  # Linux-specific configuration
  nixma.hm.linux.niri.enable = lib.mkIf pkgs.stdenv.isLinux true;

  home.packages = lib.mkIf pkgs.stdenv.isLinux [
    pkgs.google-chrome
    pkgs.slack
    pkgs.spotify
    pkgs.spotify-player
    pkgs.obsidian
    pkgs.remmina
    pkgs.nushell
    pkgs.claude-code
    pkgs.gpclient
    pkgs.pavucontrol
    pkgs.awscli2
    pkgs.aws-sso-cli
    pkgs.nixma.treewalker
    pkgs.ookla-speedtest
    pkgs.zed-editor
  ];
}
