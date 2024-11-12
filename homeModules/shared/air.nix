{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./rust.nix
    ./dev.nix
    ./debug.nix
    ./gpgagent.nix
    ./air_dconf.nix
    ./hyprland
  ];

  home.packages = [
    pkgs.google-chrome
    pkgs.slack
    pkgs.obsidian
    inputs.zen-browser.packages."${pkgs.system}".specific
  ];
}
