{ inputs, ... }:
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
    { config, lib, pkgs, ... }:
    let
      cfg = config.nixma.veila;
      tomlFormat = pkgs.formats.toml { };
    in
    {
      options.nixma.veila.settings = lib.mkOption {
        type = tomlFormat.type;
        default = { };
        description = "Veila config.toml settings";
      };

      config = lib.mkIf (cfg.settings != { }) {
        xdg.configFile."veila/config.toml".source = tomlFormat.generate "veila-config" cfg.settings;
      };
    };
}
