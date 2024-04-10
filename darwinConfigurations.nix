inputs: let
  mkDarwinConf = module: let
    home-manager = inputs.home-manager;
  in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs home-manager;};
      modules = [module];
    };
in {
  "fire" = mkDarwinConf ./darwinModules/fire.nix;
  "water" = mkDarwinConf ./darwinModules/water.nix;
}
