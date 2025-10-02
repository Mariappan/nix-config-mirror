
{ pkgs, ... }:
{
  imports = [
    ./wayland.nix
    ./cosmic-niri.nix
  ];

  services = {
    desktopManager.cosmic = {
      enable = true;
      xwayland.enable = false;
    };

    displayManager.cosmic-greeter.enable = true;
  };

  environment.systemPackages = [
    pkgs.nixma.cosmic-ext-alt
  ];
}
