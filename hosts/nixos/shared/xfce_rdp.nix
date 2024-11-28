{pkgs, ...}: {
  imports = [./xserver.nix];

  # Enable XFCE4 Desktop Environment for RDP
  services.xserver.desktopManager.xfce.enable = true;
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "xfce4-session";
  services.xrdp.openFirewall = true;

  environment.systemPackages = [
    pkgs.wl-clipboard
  ];
}
