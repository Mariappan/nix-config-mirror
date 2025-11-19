{ pkgs, ... }:
{
  # Enable xserver module
  nixma.nixos.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = [
    pkgs.wl-clipboard
    pkgs.gnomeExtensions.appindicator
  ];
}
