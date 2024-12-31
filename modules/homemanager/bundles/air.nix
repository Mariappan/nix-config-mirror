{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.google-chrome
    pkgs.slack
    pkgs.obsidian
    pkgs.remmina
    pkgs.nushell
    inputs.zen-browser.packages."${pkgs.system}".default
  ];
}
