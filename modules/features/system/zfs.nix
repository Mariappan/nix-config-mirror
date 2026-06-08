{
  flake.modules.nixos.zfs =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.nixma.nixos.zfs;
    in
    {
      options.nixma.nixos.zfs = {
        hostId = lib.mkOption {
          type = lib.types.strMatching "[0-9a-f]{8}";
          description = ''
            Unique 8-hex-digit ZFS host ID (required). ZFS uses it to detect a pool
            imported on different hardware (split-brain guard) — must be unique per host.
          '';
        };

        autoScrub = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable periodic ZFS scrub (monthly by default).";
        };

        trim = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable periodic ZFS TRIM (no-op on HDD pools; benefits the NVMe pool).";
        };

        extraPools = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "datapool"
            "fastpool"
          ];
          description = "Pools to import at boot that aren't in the cachefile.";
        };
      };

      config = {
        nixma.nixos.imported.zfs = true;

        boot.supportedFilesystems.zfs = true;
        networking.hostId = cfg.hostId;
        boot.zfs.extraPools = cfg.extraPools;
        # No ZFS root here, but set the safe value (26.11 default).
        boot.zfs.forceImportRoot = false;

        services.zfs.autoScrub.enable = cfg.autoScrub;
        services.zfs.trim.enable = cfg.trim;

        # ZFS Event Daemon — alerts + post-resilver scrub + enclosure LEDs
        services.zfs.zed.settings = {
          ZED_NOTIFY_VERBOSE = true;
          ZED_SCRUB_AFTER_RESILVER = true;
          ZED_USE_ENCLOSURE_LEDS = true;
        };
      };
    };
}
