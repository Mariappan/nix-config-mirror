inputs: let
  mkNixosConf = modules: let
    nixos = inputs.nixos;
    lanzaboote = inputs.lanzaboote;
    home-manager = inputs.home-manager;
    neovim-nightly-overlay = inputs.neovim-nightly-overlay;
  in
    nixos.lib.nixosSystem {
      specialArgs = { inherit inputs nixos home-manager lanzaboote neovim-nightly-overlay;};
      inherit modules;
    };
in {
  "air" = mkNixosConf [ ./nixosModules/air/configuration.nix ];
}
