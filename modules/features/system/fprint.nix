{
  flake.modules.nixos.fprint =
    { ... }:
    {
      nixma.nixos.imported.fprint = true;

      services.fprintd.enable = true;

      systemd.services.fprintd = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "simple";
      };
    };
}
