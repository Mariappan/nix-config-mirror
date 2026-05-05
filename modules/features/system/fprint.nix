{
  flake.modules.nixos.fprint =
    { config, lib, ... }:
    let
      cfg = config.nixma.nixos.fprint;
    in
    {
      options.nixma.nixos.fprint = {
        enable = lib.mkEnableOption "fprintd fingerprint daemon";
      };

      config = lib.mkIf cfg.enable {
        services.fprintd.enable = true;

        systemd.services.fprintd = {
          wantedBy = [ "multi-user.target" ];
          serviceConfig.Type = "simple";
        };
      };
    };
}
