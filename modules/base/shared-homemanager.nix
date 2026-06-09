{ inputs, ... }:
{
  flake.modules.nixos.shared-homemanager =
    # Each host passes its HM channel via specialArgs (required — referencing a
    # defaulted module arg in `imports` would force _module.args and recurse).
    { homeManagerModule, ... }:
    {
      nixma.nixos.imported.shared-homemanager = true;

      imports = [ homeManagerModule ];

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      # No extraSpecialArgs needed — HM modules defined via flake.modules.homeManager.*
      # capture inputs/self via lexical closure from the flake-parts module scope
      home-manager.backupFileExtension = "backup";
    };

  flake.modules.darwin.shared-homemanager =
    { ... }:
    {
      nixma.darwin.imported.shared-homemanager = true;

      imports = [ inputs.home-manager.darwinModules.home-manager ];

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
    };
}
