{
  config,
  lib,
  libx,
  ...
}:
let
  cfg = config.nixma.nixos.users.root;
in
{
  options.nixma.nixos.users.root = {
    # No additional options needed for root
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.root = libx.mkNixOsUserConf "root" {
      nixma.linux.bundles.root.enable = true;
    };
  };
}
