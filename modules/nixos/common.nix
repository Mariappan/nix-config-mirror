{
  pkgs,
  home-manager,
  ...
}:
{
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

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
    pkgs.ragenix
    pkgs.curl
    pkgs.file
    pkgs.iputils
    pkgs.helix
    pkgs.opensc
    pkgs.openssh
    pkgs.procps
    pkgs.usbutils
    pkgs.unzip
    pkgs.vim
    pkgs.zip
  ];

  system.stateVersion = "25.11";
}
