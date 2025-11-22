{
  pkgs,
  config,
  outputs,
  home-manager,
  ...
}:
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  # Enable core system modules
  nixma.nixos.hardware.enable = true;
  nixma.nixos.boot.enable = true;
  nixma.nixos.networking.enable = true;
  nixma.nixos.nix.enable = true;

  # Nixpkgs config
  nixpkgs = {
    overlays = [
      outputs.overlays.default
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = config._module.specialArgs;
  home-manager.backupFileExtension = "backup";

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

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  system.stateVersion = "25.11";
}
