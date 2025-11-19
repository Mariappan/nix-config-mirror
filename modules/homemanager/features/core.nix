{ pkgs, ... }:
{
  # Enable related features
  nixma.hm.fish.enable = true;
  nixma.hm.htop.enable = true;
  nixma.hm.tmux.enable = true;
  nixma.hm.helix.enable = true;
  nixma.hm.nvim.enable = true;
  nixma.hm.vim.enable = true;

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
