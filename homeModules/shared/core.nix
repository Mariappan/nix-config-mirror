{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.atuin
    pkgs.bat
    pkgs.chezmoi
    pkgs.cmake
    pkgs.delta  # git-delta https://github.com/dandavison/delta
    pkgs.earthly
    pkgs.expect
    pkgs.fd
    pkgs.git
    pkgs.gitui
    pkgs.gnupg
    pkgs.helix
    pkgs.htop
    pkgs.hyperfine
    pkgs.iperf
    pkgs.jq
    pkgs.lsd
    pkgs.lsof
    pkgs.ncdu
    pkgs.qpdf
    pkgs.ripgrep
    pkgs.socat
    pkgs.sshuttle
    pkgs.tldr
    pkgs.tor
    pkgs.torsocks
    pkgs.tree
    pkgs.universal-ctags
    pkgs.xsv
    pkgs.yasm
    pkgs.yubikey-manager
    pkgs.neovim-nightly
    # pkgs.ookla-speedtest # Need export NIXPKGS_ALLOW_UNFREE=1
  ];

  home.stateVersion = "23.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
