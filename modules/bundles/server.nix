{ self, ... }:
{
  flake.modules.nixos.server =
    { lib, ... }:
    {
      nixma.nixos.imported.server = true;

      imports = [
        self.modules.nixos.headless
      ];

      # Server hosts don't need on-host docs (NixOS manual, nix manual, man-db).
      documentation.enable = lib.mkForce false;
    };
}
