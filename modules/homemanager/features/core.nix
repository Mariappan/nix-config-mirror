{ pkgs, lib, ... }:
{
  # Enable related features
  nixma.hm.fish.enable = true;
  nixma.hm.htop.enable = true;
  nixma.hm.tmux.enable = true;
  nixma.hm.helix.enable = true;
  nixma.hm.nvim.enable = true;
  nixma.hm.vim.enable = true;
  nixma.hm.xdg.enable = lib.mkIf pkgs.stdenv.isLinux true;

  home.packages = [
    pkgs.file
    pkgs.jq
    pkgs.python3
    pkgs.rsync
    pkgs.tor
    pkgs.torsocks
    pkgs.unzip
    pkgs.wget
    pkgs.zip
  ];

  programs.atuin.enable = true;
  programs.atuin.enableFishIntegration = true;
  programs.atuin.flags = [ "--disable-ctrl-r" ];

  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
    config = {
      global.hide_env_diff = true;
    };
  };

  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
