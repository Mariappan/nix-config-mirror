{ self, ... }:
{
  flake.modules.nixos.shared-nixpkgs =
    { ... }:
    {
      nixpkgs = {
        overlays = [
          self.overlays.default
          self.overlays.additions
          self.overlays.modifications
          self.overlays.stable-packages
        ];
        config = {
          allowUnfree = true;
          segger-jlink.acceptLicense = true;
        };
      };
    };

  flake.modules.darwin.shared-nixpkgs =
    { ... }:
    {
      nixpkgs = {
        overlays = [
          self.overlays.default
          self.overlays.additions
          self.overlays.modifications
          self.overlays.stable-packages
        ];
        config = {
          allowUnfree = true;
          segger-jlink.acceptLicense = true;
        };
      };
    };
}
