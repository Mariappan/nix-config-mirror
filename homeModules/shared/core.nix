{pkgs, inputs,  ...}: {
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
    pkgs.file
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
    pkgs.devenv
    #pkgs.jetbrains.rust-rover
    #pkgs.jetbrains.jdk
    #pkgs.yubikey-manager
    # pkgs.ookla-speedtest # Need export NIXPKGS_ALLOW_UNFREE=1
  ];

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    withPython3 = true;
  };

  programs.atuin.enable = true;
  programs.atuin.enableFishIntegration = true;
  programs.atuin.flags = ["--disable-ctrl-r"];

  programs.htop.enable = true;
  programs.htop.settings = {
    hide_kernel_threads = true;
    hide_userland_threads = true;
    hide_running_in_container = false;
    shadow_other_users = true;
    show_thread_names = true;
    show_program_path = true;
    highlight_base_name = true;
    highlight_deleted_exe = true;
    highlight_threads = true;
    find_comm_in_cmdline = true;
    strip_exe_from_cmdline = true;
    show_merged_command = true;
    header_margin = true;
    cpu_count_from_one = 1;
    tree_view = true;
  };

  home.stateVersion = "23.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
