{ self, ... }:
{
  flake.modules.nixos.xserver =
    { pkgs, ... }:
    {
      nixma.nixos.imported.xserver = true;

      imports = [ self.modules.nixos.gui ];

      services.xserver = {
        enable = true;

        xkb = {
          layout = "us";
          variant = "";
        };
      };

      environment.systemPackages = [
        pkgs.libnotify
      ];
    };
}
