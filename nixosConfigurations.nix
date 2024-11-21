inputs: let
  mkNixosConf = modules: let
    nixpkgs = inputs.nixpkgs;
    lanzaboote = inputs.lanzaboote;
    home-manager = inputs.home-manager;
  in
    nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs nixpkgs home-manager lanzaboote;};
      inherit modules;
    };
in {
  "air" = mkNixosConf [./nixosModules/air/configuration.nix];
  "blackmamba" = mkNixosConf [./nixosModules/blackmamba/configuration.nix];
  "earth" = mkNixosConf [./nixosModules/earth/configuration.nix];
}
