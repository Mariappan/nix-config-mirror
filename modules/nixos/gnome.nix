{ pkgs, ... }:
{
  imports = [ ./xserver.nix ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = [
    pkgs.wl-clipboard
    pkgs.gnomeExtensions.appindicator
  ];
}
