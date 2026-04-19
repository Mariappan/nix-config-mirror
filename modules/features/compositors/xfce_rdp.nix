{ self, ... }:
{
  flake.modules.nixos.xfce_rdp =
    { ... }:
    {
      imports = [ self.modules.nixos.xserver ];

      # Enable XFCE4 Desktop Environment for RDP
      services.xserver.desktopManager.xfce.enable = true;
      services.xrdp.enable = true;
      services.xrdp.defaultWindowManager = "xfce4-session";
      services.xrdp.openFirewall = true;
    };
}
