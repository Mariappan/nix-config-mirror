{ inputs, ... }:
{
  flake.modules.nixos.wayland-dm =
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
            "tuigreet"
            "cosmic-greeter"
            "noctalia-greeter"
          ];
          default = "noctalia-greeter";
          description = "Display manager to use for Wayland";
        };
      };

      imports = [ inputs.noctalia-greeter.nixosModules.default ];

      config = {
        nixma.nixos.imported.wayland-dm = true;

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

        services.greetd = lib.mkIf (cfg.displayManager == "tuigreet") {
          enable = true;
          settings.default_session = {
            command = lib.concatStringsSep " " [
              "${pkgs.tuigreet}/bin/tuigreet"
              "--time"
              "--remember"
              "--remember-session"
              "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
            ];
            user = "greeter";
          };
        };

        services.displayManager.cosmic-greeter.enable = lib.mkIf (
          cfg.displayManager == "cosmic-greeter"
        ) true;

        programs.noctalia-greeter.enable = lib.mkIf (cfg.displayManager == "noctalia-greeter") true;
      };
    };
}
