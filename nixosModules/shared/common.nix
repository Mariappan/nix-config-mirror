{pkgs, config, lib, inputs, home-manager, ...}: {

  imports = [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = config._module.specialArgs;
    }
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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ];
  # Following optimize on every build but may result in slow build time
  # nix.settings.auto-optimise-store = true;

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

  environment.shells = [ pkgs.bashInteractive pkgs.zsh pkgs.fish ];

  system.stateVersion = "23.11";
}

