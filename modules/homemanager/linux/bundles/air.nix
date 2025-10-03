{ pkgs, ... }: {
  nixma.core.enable = true;
  nixma.git.enable = true;
  nixma.jujutsu.enable = true;
  nixma.rust.enable = true;
  nixma.dev.enable = true;
  nixma.debug.enable = true;
  nixma.gpgagent.enable = true;
  nixma.neovide.enable = true;
  nixma.wezterm.enable = true;

  nixma.linux.dconf.enable = true;
  nixma.linux.nixos.enable = true;
  nixma.linux.xdg.enable = true;

  nixma.linux.niri.enable = true;

  home.packages = [
    pkgs.google-chrome
    pkgs.slack
    pkgs.spotify
    pkgs.obsidian
    pkgs.remmina
    pkgs.nushell
    pkgs.vivaldi-wayland
    pkgs.claude-code
    pkgs.gpclient
    pkgs.neovide
    pkgs.pavucontrol
    pkgs.spicetify-cli
    pkgs.awscli2
    pkgs.aws-sso-cli
    pkgs.nixma.treewalker
    pkgs.ookla-speedtest
  ];
}
