{ self, ... }:
{
  flake.modules.nixos.gnome =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.nixma.nixos.gnome;
    in
    {
      imports = [ self.modules.nixos.nautilus ];

      options.nixma.nixos.gnome.enable = lib.mkEnableOption "GNOME desktop environment with GDM";

      config = lib.mkIf cfg.enable {
        services.displayManager.gdm.enable = true;
        services.desktopManager.gnome.enable = true;

        environment.systemPackages = [
          pkgs.wl-clipboard
          pkgs.gnomeExtensions.appindicator
        ];
      };
    };
}
