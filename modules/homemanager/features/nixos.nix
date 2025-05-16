{pkgs, ...}: {
  imports = [./wezterm.nix];

  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
    config = {
      global.hide_env_diff = true;
    };
  };

  home.packages = [
    pkgs.iputils
    pkgs.victor-mono
    pkgs.firefox
  ];

  programs.command-not-found.enable = false;
}
