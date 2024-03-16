inputs: let
  mkDarwinConf = module: let
    home-manager = inputs.home-manager;
    neovim-nightly-overlay = inputs.neovim-nightly-overlay;
  in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs home-manager neovim-nightly-overlay;};
      modules = [ module ];
    };
in {
  "fire" = mkDarwinConf ./darwinModules/fire.nix;
  "water" = mkDarwinConf ./darwinModules/water.nix;
}
