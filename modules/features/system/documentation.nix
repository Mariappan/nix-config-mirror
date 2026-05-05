{ self, ... }:
{
  flake.modules.nixos.documentation =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.nixma.nixos.documentation;
    in
    {
      options.nixma.nixos.documentation.enable = lib.mkOption {
        type = lib.types.bool;
        default = !lib.elem "server" config.nixma.nixos.roles;
        description = "On-host docs (NixOS manual, nix manual, man-db). Default off on server hosts.";
      };

      config = {
        documentation.enable = cfg.enable;

        # Workstations get the standard man-page corpora.
        environment.systemPackages =
          lib.mkIf (cfg.enable && lib.elem "workstation" config.nixma.nixos.roles)
            [
              pkgs.man-pages
              pkgs.man-pages-posix
            ];
      };
    };
}
