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
  ];

  # Enable core system modules
  nixma.nixos.hardware.enable = true;
  nixma.nixos.boot.enable = true;
  nixma.nixos.networking.enable = true;
  nixma.nixos.nix.enable = true;
  nixma.nixos.i18n.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # BPF tools
  programs.bcc.enable = true;

  environment.shells = [
    pkgs.bashInteractive
    pkgs.zsh
    pkgs.fish
  ];

  environment.systemPackages = [
    pkgs.curl
    pkgs.nix-alien
    pkgs.opensc
    pkgs.openssh
    pkgs.sbctl
    pkgs.usbutils
    pkgs.procps
    pkgs.helix
    pkgs.vim
  ];

  services.udisks2.enable = true;

  system.stateVersion = "25.11";
}
