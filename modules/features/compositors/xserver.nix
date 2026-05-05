{ self, ... }:
{
  flake.modules.nixos.xserver =
    { pkgs, ... }:
    {
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
