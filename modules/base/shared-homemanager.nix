{
  flake.modules.nixos.shared-homemanager = { ... }: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    # No extraSpecialArgs needed — HM modules defined via flake.modules.homeManager.*
    # capture inputs/self via lexical closure from the flake-parts module scope
    home-manager.backupFileExtension = "backup";
  };

  flake.modules.darwin.shared-homemanager = { ... }: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    # No extraSpecialArgs needed — HM modules defined via flake.modules.homeManager.*
    # capture inputs/self via lexical closure from the flake-parts module scope
    home-manager.backupFileExtension = "backup";
  };
}
