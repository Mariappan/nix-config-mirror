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

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ];
  # Following optimize on every build but may result in slow build time
  # nix.settings.auto-optimise-store = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = config._module.specialArgs;
  home-manager.backupFileExtension = "backup";

  environment.systemPackages = [
    pkgs.curl
    pkgs.git
    pkgs.nix-alien
    pkgs.opensc
    pkgs.openssh
    pkgs.sbctl
    pkgs.usbutils
    pkgs.procps
    pkgs.helix
    pkgs.vim
  ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # BPF tools
  programs.bcc.enable = true;

  environment.shells = [
    pkgs.bashInteractive
    pkgs.zsh
    pkgs.fish
  ];

  # For running native binaries without patchelf
  programs.nix-ld.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/maari/nix-config";
  };

  networking.timeServers = [
    "0.sg.pool.ntp.org"
    "1.sg.pool.ntp.org"
    "2.sg.pool.ntp.org"
    "3.sg.pool.ntp.org"
  ];
  services.ntp.enable = true;

  services.udisks2.enable = true;

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

  system.stateVersion = "25.11";
}
