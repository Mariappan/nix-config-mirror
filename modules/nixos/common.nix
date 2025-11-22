{
  pkgs,
  home-manager,
  ...
}:
{
  imports = [
    home-manager.nixosModules.home-manager
    ../shared/nixpkgs.nix
    ../shared/homemanager.nix
    ../shared/shells.nix
  ];

  # Enable core system modules
  nixma.nixos.hardware.enable = true;
  nixma.nixos.boot.enable = true;
  nixma.nixos.networking.enable = true;
  nixma.nixos.nix.enable = true;
  nixma.nixos.i18n.enable = true;

  environment.systemPackages = [
    pkgs.curl
    pkgs.opensc
    pkgs.openssh
    pkgs.sbctl
    pkgs.usbutils
    pkgs.iputils
    pkgs.procps
    pkgs.helix
    pkgs.vim
  ];

  system.stateVersion = "25.11";
}
