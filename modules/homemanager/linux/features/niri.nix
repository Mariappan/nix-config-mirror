{ pkgs, ... }: {
  imports = [
    ./wayland
    ./ghostty.nix
    ./foot.nix
    ./wayland/waybar.nix
    ./wayland/swaync.nix
    ./wayland/walker.nix
    ./wayland/swww.nix
  ];

  programs.niri.enable = true;

  xdg.portal = {
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };

  home.packages = [
    pkgs.hyprlock
  ];
}
