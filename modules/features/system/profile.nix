{ self, ... }:
{
  flake.modules.nixos.profile =
    { config, lib, ... }:
    let
      cfg = config.nixma.nixos;
      hasRole = role: lib.elem role cfg.roles;
    in
    {
      options.nixma.nixos = {
        formFactor = lib.mkOption {
          type = lib.types.enum [
            "sbc"
            "laptop"
            "desktop"
            "vm"
          ];
          description = ''
            Physical form factor of the host. Drives default hardware tuning
            (firmware curation, microcode, power management, docs).
          '';
        };

        roles = lib.mkOption {
          type = lib.types.listOf (lib.types.enum [
            "workstation"
            "builder"
            "server"
          ]);
          default = [ ];
          description = ''
            Functional roles this host fills. Drives default service and
            package selection. Multiple roles may be combined.
          '';
        };
      };

      config = lib.mkMerge [
        # SBC: known hardware, no installer-scan firmware fallback, no docs.
        # Plain `false` (no mkDefault) so it overrides the mkDefault true from
        # nixpkgs not-detected.nix imported via hardware.nix.
        (lib.mkIf (cfg.formFactor == "sbc") {
          hardware.enableRedistributableFirmware = false;
          hardware.wirelessRegulatoryDatabase = lib.mkDefault false;
        })

        # Server role: drop docs (manual + man-db indexing).
        (lib.mkIf (hasRole "server") {
          documentation.enable = lib.mkDefault false;
        })
      ];
    };
}
