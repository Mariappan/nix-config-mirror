{
  pkgs,
  config,
  lib,
  inputs,
  home-manager,
  ...
}: {
  imports = [
    home-manager.nixosModules.home-manager
    ./fishpathfix.nix
  ];

  # Nixpkgs config
  nixpkgs = {
    overlays = [
      (import ../../overlays inputs).default
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.optimise.automatic = true;
  nix.optimise.dates = ["03:45"];
  # Following optimize on every build but may result in slow build time
  # nix.settings.auto-optimise-store = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = config._module.specialArgs;
  home-manager.backupFileExtension = "backup";

  environment.systemPackages = [
    pkgs.curl
    pkgs.opensc
    pkgs.openssh
    pkgs.git
    pkgs.sbctl
    pkgs.vim
  ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  programs.bcc.enable = true;

  environment.shells = [pkgs.bashInteractive pkgs.zsh pkgs.fish];

  # For running native binaries without patchelf
  programs.nix-ld.enable = true;
  programs.nh = {
    enable = true;
    # clean.enable = true;
    # clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/maari/nix-config";
  };

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;

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

  system.stateVersion = "23.11";
}
