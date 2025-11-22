{ pkgs, ... }:
{
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = [
    pkgs.wl-clipboard
    pkgs.gnomeExtensions.appindicator
  ];
}
