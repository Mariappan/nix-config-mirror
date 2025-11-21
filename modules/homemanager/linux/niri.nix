{ pkgs, ... }:
{
  # Enable related features
  nixma.hm.linux.wayland.enable = true;
  nixma.hm.linux.wayland.stasis.enable = true;
  nixma.hm.linux.wayland.kanshi.enable = true;
  nixma.hm.linux.hyprlock.enable = true;
  nixma.hm.linux.ghostty.enable = true;

  programs.niri.enable = true;

  services.vicinae.enable = true;

  # Polkit for auth
  services.polkit-gnome.enable = true;

  # Poral for xdg-open
  xdg.portal = {
    config = {
      niri = {
        default = [
          "gtk"
          "gnome"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.portal.FileChooser" = [ "xdg-desktop-portal-gtk" ];
      };
    };
  };
}
