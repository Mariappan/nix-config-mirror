{ pkgs, ... }: {
  imports = [
    ./wayland
    ./ghostty.nix
    ./foot.nix
  ];

  programs.niri.enable = true;
  programs.dankMaterialShell.enable = true;
  programs.dankMaterialShell.enableSystemd = true;

  xdg.portal = {
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };

  home.packages = [
    pkgs.hyprlock
  ];
}
