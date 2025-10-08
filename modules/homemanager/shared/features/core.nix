{ pkgs, ... }:
{
  imports = [
    ./fish
    ./htop.nix
    ./tmux.nix
    ./helix.nix
    ./nvim.nix
    ./vim.nix
  ];

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
