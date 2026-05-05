{ self, ... }:
{
  flake.modules.nixos.xfce_rdp =
    { ... }:
    {
      nixma.nixos.imported.xfce_rdp = true;

      imports = [ self.modules.nixos.xserver ];

      services.xserver.desktopManager.xfce.enable = true;
      services.xrdp.enable = true;
      services.xrdp.defaultWindowManager = "xfce4-session";
      services.xrdp.openFirewall = true;
    };
}
