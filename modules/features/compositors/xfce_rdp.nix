{ self, ... }:
{
  flake.modules.nixos.xfce_rdp =
    { config, lib, ... }:
    let
      cfg = config.nixma.nixos.xfce_rdp;
    in
    {
      imports = [ self.modules.nixos.xserver ];

      options.nixma.nixos.xfce_rdp.enable = lib.mkEnableOption "XFCE4 desktop served over xrdp";

      config = lib.mkIf cfg.enable {
        nixma.nixos.xserver.enable = lib.mkDefault true;
        services.xserver.desktopManager.xfce.enable = true;
        services.xrdp.enable = true;
        services.xrdp.defaultWindowManager = "xfce4-session";
        services.xrdp.openFirewall = true;
      };
    };
}
