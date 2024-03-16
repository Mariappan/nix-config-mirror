inputs: let
  mkNixosConf = modules: let
    nixos = inputs.nixos;
    home-manager = inputs.home-manager;
    neovim-nightly-overlay = inputs.neovim-nightly-overlay;
  in
    nixos.lib.nixosSystem {
      specialArgs = { inherit inputs nixos home-manager neovim-nightly-overlay;};
      inherit modules;
    };
in {
  "air" = mkNixosConf [ ./nixosModules/air/configuration.nix ];
}
