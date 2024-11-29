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
    inputs.zen-browser.packages."${pkgs.system}".specific
  ];
}
