{ config, pkgs, inputs, ... }:

{
  imports = [
    ./fish
    ./tmux.nix
    ./helix.nix
    ./vim.nix
  ];

  home.packages = [
    pkgs.atuin
    pkgs.bat
    pkgs.chezmoi
    pkgs.cmake
    pkgs.difftastic
    pkgs.earthly
    pkgs.expect
    pkgs.fd
    pkgs.fzf
    pkgs.gnupg
    pkgs.helix
    pkgs.htop
    pkgs.hurl
    pkgs.hyperfine
    pkgs.inetutils
    pkgs.iperf
    pkgs.jq
    pkgs.lsd
    pkgs.lsof
    pkgs.ncdu
    pkgs.qpdf
    pkgs.python3
    pkgs.rsync
    pkgs.rustup
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
    pkgs.zip
    pkgs.unzip
    pkgs.wget
    pkgs.whois
    pkgs.sshpass
    pkgs.termshark
    pkgs.neovim
    #pkgs.zellij
    #pkgs.jetbrains.rust-rover
    #pkgs.jetbrains.jdk
    #pkgs.yubikey-manager
    #pkgs.neovim-nightly
    # pkgs.ookla-speedtest # Need export NIXPKGS_ALLOW_UNFREE=1
  ];

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlay
  ];

  programs.atuin.enable = true;
  programs.atuin.enableFishIntegration = true;
  programs.atuin.flags = [ "--disable-ctrl-r" ];

  programs.htop.enable = true;
  programs.htop.settings = {
    hide_kernel_threads = true;
    hide_userland_threads = true;
  };

  home.stateVersion = "23.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
