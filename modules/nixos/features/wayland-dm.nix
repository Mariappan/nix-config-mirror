{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixma.nixos.wayland-dm;
in
{
  options.nixma.nixos.wayland-dm = {
    displayManager = lib.mkOption {
      type = lib.types.enum [
        "gdm"
        "regreet"
        "cosmic-greeter"
      ];
      default = "gdm";
      description = "Display manager to use for Wayland";
    };
  };

  config = {
    services.displayManager.gdm.enable = lib.mkIf (cfg.displayManager == "gdm") true;

    programs.regreet = lib.mkIf (cfg.displayManager == "regreet") {
      enable = true;
      settings = {
        gtk.application_prefer_dark_theme = true;
      };
      cursorTheme.name = "Adwaita";
      cursorTheme.package = pkgs.adwaita-icon-theme;
      theme.name = "adw-gtk3-dark";
      theme.package = pkgs.adw-gtk3;
    };

    services.displayManager.cosmic-greeter.enable = lib.mkIf (
      cfg.displayManager == "cosmic-greeter"
    ) true;
  };
}
