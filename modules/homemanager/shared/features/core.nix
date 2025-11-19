{ pkgs, ... }:
{
  # Enable related features
  nixma.fish.enable = true;
  nixma.htop.enable = true;
  nixma.tmux.enable = true;
  nixma.helix.enable = true;
  nixma.nvim.enable = true;
  nixma.vim.enable = true;

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

  programs.nix-index.enable = true;

  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
