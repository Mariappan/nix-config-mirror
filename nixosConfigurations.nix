inputs: let
  mkNixosConf = modules: let
    nixos = inputs.nixos;
    lanzaboote = inputs.lanzaboote;
    home-manager = inputs.home-manager;
  in
    nixos.lib.nixosSystem {
      specialArgs = {inherit inputs nixos home-manager lanzaboote;};
      inherit modules;
    };
in {
  "air" = mkNixosConf [./nixosModules/air/configuration.nix];
}
