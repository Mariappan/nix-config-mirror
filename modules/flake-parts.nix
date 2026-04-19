{ inputs, ... }:
{
  imports = [
    # Patched flakeModules.modules to set key for deduplication (upstream PR #251)
    (
      { lib, moduleLocation, ... }:
      let
        inherit (lib.strings) escapeNixIdentifier;
        addInfo =
          class: moduleName: module:
          if class == "generic" then
            module
          else
            let
              loc = "${toString moduleLocation}#modules.${escapeNixIdentifier class}.${escapeNixIdentifier moduleName}";
            in
            {
              _class = class;
              _file = loc;
              key = loc;
              imports = [ module ];
            };
      in
      {
        options.flake.modules = lib.mkOption {
          type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
          apply =
            lib.warn "flake-parts: local key deduplication patch is active. Remove once hercules-ci/flake-parts#251 is merged."
              (lib.mapAttrs (k: lib.mapAttrs (addInfo k)));
        };
      }
    )
  ];

  systems = [
    "x86_64-linux"
    "x86_64-darwin"
    "aarch64-linux"
    "aarch64-darwin"
  ];
}
