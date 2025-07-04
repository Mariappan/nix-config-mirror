{pkgs, ...}: {
  nixma.rust.enable = true;
  nixma.dev.enable = true;
  nixma.debug.enable = true;
  nixma.gpgagent.enable = true;
  nixma.hyprland.enable = true;

  home.packages = [
    pkgs.vivaldi
  ];
}
