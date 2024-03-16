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

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ];
  # Following optimize on every build but may result in slow build time
  # nix.settings.auto-optimise-store = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.curl
    pkgs.opensc
    pkgs.openssh
    pkgs.vim
  ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  programs.direnv.enable = true;
  programs.direnv.loadInNixShell = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.silent = false;

  programs.tmux.enable = true;

  environment.shells = [ pkgs.bashInteractive pkgs.zsh pkgs.fish ];

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlay
  ];

  system.stateVersion = "23.11";
}

