{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ ];
      };

      packages = import ../packages { inherit pkgs; };
      formatter = pkgs.nixfmt-tree;
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nixd
        ];
      };
    };
}
