{ self, ... }:
{
  flake.modules.nixos.xserver =
    { pkgs, ... }:
    {
      imports = [ self.modules.nixos.gui ];

      services.xserver = {
        # Enable the X11 windowing system.
        enable = true;

        # Configure keymap in X11
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
