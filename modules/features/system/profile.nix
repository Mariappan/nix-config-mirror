{ self, ... }:
{
  flake.modules.nixos.profile =
    { lib, ... }:
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
            Physical form factor of the host. Consumed by feature modules to
            tune hardware-related defaults (firmware curation, microcode,
            power management).
          '';
        };

        roles = lib.mkOption {
          type = lib.types.listOf (
            lib.types.enum [
              "workstation"
              "builder"
              "server"
            ]
          );
          default = [ ];
          description = ''
            Functional roles this host fills. Consumed by feature modules to
            tune service and package selection. Multiple roles may be combined.
          '';
        };
      };
    };
}
