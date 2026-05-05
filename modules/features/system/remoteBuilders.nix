{ self, ... }:
{
  flake.modules.nixos.remoteBuilders =
    { config, lib, ... }:
    let
      cfg = config.nixma.nixos.remoteBuilders;
    in
    {
      options.nixma.nixos.remoteBuilders = {
        sshKey = lib.mkOption {
          type = lib.types.path;
          default = "/root/.ssh/id_ed25519_nixbuilder";
          description = ''
            SSH private key path used by the local nix-daemon (root) to log
            into builders. Must exist on disk and be readable by root.
          '';
        };

        machines = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule (
              { name, ... }:
              {
                options = {
                  hostName = lib.mkOption {
                    type = lib.types.str;
                    description = "FQDN or IP that root can reach over SSH.";
                  };
                  sshUser = lib.mkOption {
                    type = lib.types.str;
                    default = "root";
                    description = "SSH user. Must be in remote nix trusted-users.";
                  };
                  systems = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    description = "Nix systems supported, e.g. [ \"aarch64-linux\" ].";
                  };
                  maxJobs = lib.mkOption {
                    type = lib.types.int;
                    default = 4;
                  };
                  speedFactor = lib.mkOption {
                    type = lib.types.int;
                    default = 1;
                  };
                  supportedFeatures = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [
                      "kvm"
                      "big-parallel"
                      "benchmark"
                    ];
                  };
                  mandatoryFeatures = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [ ];
                  };
                };
              }
            )
          );
          default = { };
          description = "Named build machines, keyed by short label.";
        };
      };

      config = lib.mkIf (cfg.machines != { }) {
        nixma.nixos.imported.remoteBuilders = true;

        nix.distributedBuilds = true;

        nix.buildMachines = lib.mapAttrsToList (_: m: {
          inherit (m)
            hostName
            sshUser
            systems
            maxJobs
            speedFactor
            supportedFeatures
            mandatoryFeatures
            ;
          protocol = "ssh-ng";
          sshKey = toString cfg.sshKey;
        }) cfg.machines;
      };
    };
}
