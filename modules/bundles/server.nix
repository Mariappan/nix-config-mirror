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
      # `documentation.man.enable` defaults to true independently of
      # `documentation.enable`, so disable it manually
      documentation.enable = lib.mkForce false;
      documentation.man.enable = lib.mkForce false;

      # Headless: drop GUI-flavored defaults that NixOS turns on for desktops.
      # Net savings on chip / rock3c / dull5080 closures: ~60-90 MiB.
      #
      xdg.icons.enable = lib.mkDefault false;
      xdg.mime.enable = lib.mkDefault false;
      xdg.sounds.enable = lib.mkDefault false;
      fonts.fontconfig.enable = lib.mkDefault false;
    };
}
