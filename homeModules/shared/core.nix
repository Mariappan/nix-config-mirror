{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./fish
    ./tmux.nix
    ./helix.nix
    ./nvim.nix
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
    pkgs.neovim-nightly
    pkgs.devenv
    #pkgs.jetbrains.rust-rover
    #pkgs.jetbrains.jdk
    #pkgs.yubikey-manager
    # pkgs.ookla-speedtest # Need export NIXPKGS_ALLOW_UNFREE=1
  ];

  programs.atuin.enable = true;
  programs.atuin.enableFishIntegration = true;
  programs.atuin.flags = ["--disable-ctrl-r"];

  programs.htop.enable = true;
  programs.htop.settings = {
    hide_kernel_threads = true;
    hide_userland_threads = true;
  };

  home.stateVersion = "23.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
