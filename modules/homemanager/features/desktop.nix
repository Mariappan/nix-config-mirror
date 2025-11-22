{ pkgs, lib, ... }:
{
  nixma.hm.tmux.enable = true;
  nixma.hm.helix.enable = true;
  nixma.hm.nvim.enable = true;
  nixma.hm.vim.enable = true;
  nixma.hm.xdg.enable = lib.mkIf pkgs.stdenv.isLinux true;

  home.packages = [
    pkgs.python3
    pkgs.rsync
    pkgs.wget
  ];

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    flags = [ "--disable-ctrl-r" ];
  };

  programs.command-not-found.enable = false;
  # nix-index-database will automatically be installed
  # https://github.com/nix-community/nix-index-database/blob/469ef53571ea80890c9497952787920c79c1ee6e/home-manager-module.nix#L23
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
}
