{
  flake.modules.nixos.docker =
    { config, lib, ... }:
    let
      cfg = config.nixma.nixos.docker;
    in
    {
      options.nixma.nixos.docker.enable =
        lib.mkEnableOption "Docker daemon with auto-prune and scoped IP pools";

      config = lib.mkIf cfg.enable {
        virtualisation.docker.enable = true;
        virtualisation.docker.autoPrune.enable = true;
        virtualisation.docker.daemon.settings = {
          bip = "10.153.1.1/24";
          default-address-pools = [
            {
              base = "10.153.2.0/18";
              size = 24;
            }
          ];
        };
      };
    };
}
