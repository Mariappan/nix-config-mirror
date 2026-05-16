{ self, inputs, ... }:
{
  flake.modules.nixos.veila =
    { pkgs, ... }:
    let
      veila = inputs.veila.packages.${pkgs.stdenv.system}.veila;
    in
    {
      nixma.nixos.imported.veila = true;

      security.pam.services.veila = {
        unixAuth = true;
        u2fAuth = true;
      };

      environment.systemPackages = [ veila ];

      systemd.user.services.veilad = {
        description = "Veila lockscreen daemon";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${veila}/bin/veilad";
          Restart = "on-failure";
          RestartSec = 3;
        };
      };

      systemd.user.services.veila-idle = {
        description = "Veila idle auto-lock + lock-before-sleep";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "veilad.service" "graphical-session.target" ];
        requires = [ "veilad.service" ];
        serviceConfig = {
          ExecStart = "${veila}/bin/veila idle --lock-after=86400 --lock-before-sleep";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };

  flake.modules.homeManager.veila =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.nixma.veila;
      tomlFormat = pkgs.formats.toml { };
      themeNames = lib.mapAttrsToList (n: _: lib.removeSuffix ".toml" n) (
        lib.filterAttrs (n: _: lib.hasSuffix ".toml" n) (builtins.readDir (self + /dotfiles/veila/themes))
      );
    in
    {
      options.nixma.veila = {
        theme = lib.mkOption {
          type = lib.types.enum themeNames;
          default = "goku";
          description = "Active veila theme (matches a file in dotfiles/veila/themes/).";
        };
        settings = lib.mkOption {
          type = tomlFormat.type;
          default = { };
          description = "Extra overrides merged into config.toml.";
        };
      };

      config = {
        nixma.imported.veila = true;

        xdg.configFile."veila/config.toml".source = tomlFormat.generate "veila-config" (
          { theme = cfg.theme; } // cfg.settings
        );
        xdg.configFile."veila/themes".source = self + /dotfiles/veila/themes;
        xdg.configFile."veila/wallpaper".source = self + /wallpapers;
      };
    };
}
