{ config, pkgs, inputs, ... }:

{
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
    pkgs.git-absorb
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
  programs.tmux.terminal = "screen-256color";
  programs.tmux.historyLimit = 20000;
  programs.tmux.keyMode = "vi";
  programs.tmux.mouse = true;
  programs.tmux.shortcut = "a";

  programs.htop.enable = true;
  programs.htop.settings = {
    hide_kernel_threads = true;
    hide_userland_threads = true;
  };

  programs.git.enable = true;
  programs.git.aliases = {
    graphviz = "!f() { echo 'digraph git {' ; git log --pretty='format:  %h -> { %p }' \"$@\" | sed 's/[0-9a-f][0-9a-f]*/\"&\"/g' ; echo '}'; }; f";
    root = "rev-parse --show-toplevel";
  };
  programs.gitui.enable = true;
  programs.git.delta.enable = true;
  programs.git.delta.options = {
    decorations = {
      commit-decoration-style = "bold yellow box ul";
      file-decoration-style = "none";
      file-style = "bold yellow ul";
    };
    features = "line-numbers decorations";
    whitespace-error-style = "22 reverse";
  };
  programs.git.extraConfig = {
    core = {
      whitespace = "trailing-space,space-before-tab";
    };
    color = {
      ui = true;
      diff = {
        meta = 227;
        frag = "magenta bold";
        commit = "227 bold";
        old = "red bold";
        new = "green bold";
        whitespace = "red reverse";
     };
    };
    rerere = {
      enabled = true;
      autoupdate = true;
    };
    tag = {
      forceSignAnnotated = true;
    };
    push = {
      default = "simple";
    };
    init = {
      defaultBranch = "main";
    };
  };

  home.stateVersion = "23.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
