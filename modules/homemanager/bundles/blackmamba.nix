{pkgs, ...}: {
  nixma.core.enable = true;
  nixma.nixos.enable = true;
  nixma.git.enable = true;
  nixma.jujutsu.enable = true;
  nixma.xdg.enable = true;
  nixma.rust.enable = true;
  nixma.dev.enable = true;
  nixma.debug.enable = true;
  nixma.hyprland.enable = true;

  home.packages = [
    pkgs.google-chrome
    pkgs.obsidian
  ];
}
