{ self, inputs, ... }:
{
  flake.modules.nixos.veila =
    { pkgs, ... }:
    let
      veila = inputs.veila.packages.${pkgs.stdenv.system}.veila;
    in
    {
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
        xdg.configFile."veila/config.toml".source = tomlFormat.generate "veila-config" (
          { theme = cfg.theme; } // cfg.settings
        );
        xdg.configFile."veila/themes".source = self + /dotfiles/veila/themes;
        xdg.configFile."veila/wallpaper".source = self + /wallpapers;
      };
    };
}
