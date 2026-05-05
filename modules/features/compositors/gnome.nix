{ self, ... }:
{
  flake.modules.nixos.gnome =
    { pkgs, ... }:
    {
      imports = [
        self.modules.nixos.nautilus
        self.modules.nixos.gui
      ];

      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      environment.systemPackages = [
        pkgs.wl-clipboard
        pkgs.gnomeExtensions.appindicator
      ];
    };
}
