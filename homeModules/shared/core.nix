{ config, pkgs, inputs, ... }:

{
  imports = [
    ./fish.nix
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

  programs.tmux.enable = true;
  programs.tmux.terminal = "tmux-256color";
  programs.tmux.historyLimit = 20000;
  programs.tmux.keyMode = "vi";
  programs.tmux.mouse = true;
  programs.tmux.shortcut = "a";
  programs.tmux.baseIndex = 1;
  programs.tmux.shell = "\${pkgs.fish}/bin/fish";
  programs.tmux.extraConfig = ''
  set -as terminal-features ",alacritty*:RGB"
  set -as terminal-overrides ",*:U8=0"

  set -g set-titles-string '#S:#I.#P #W'
  set -g @yank_selection 'primary'

  # Status
  set -g status "on"
  set -g status-bg "#303030"
  set -g status-justify "left"
  set -g status-right-length "100"
  set -g status-left-length "100"

  setw -g window-status-separator ""
  set -g status-interval 10

  set -g status-left "#[fg=#deddda] 【 #S 】"
  set -g status-right "#[fg=#deddda] 【 #h 】【 %Y-%m-%d %I:%M %p 】 "
  setw -g window-status-format " #I-#W "
  setw -g window-status-current-format "#[bg=#1d1d1d] #I-#W "

  setw -g status-style "fg=colour7"
  setw -ag status-style "bg=#4f4f4f
  '';

  programs.htop.enable = true;
  programs.htop.settings = {
    hide_kernel_threads = true;
    hide_userland_threads = true;
  };

  home.stateVersion = "23.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
