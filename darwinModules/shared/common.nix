{pkgs, config, lib, inputs, home-manager, ...}: {

  imports = [
    home-manager.darwinModules.home-manager
    ./fishpathfix.nix
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nix.gc = {
    user = "root";
    automatic = true;
    interval = { Weekday = 0; Hour = 2; Minute = 0; };
    options = "--delete-older-than 7d";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.curl
    pkgs.opensc
    pkgs.openssh
    pkgs.pinentry_mac
    pkgs.vim
  ];

  # programs.git.enable = true;
  # services.openssh.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  programs.direnv.enable = true;
  programs.direnv.loadInNixShell = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.silent = false;

  programs.tmux.enable = true;
  # programs.tmux.terminal = "screen-256color";

  environment.shells = [ pkgs.bashInteractive pkgs.zsh pkgs.fish ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [ "homebrew/cask-versions" ];
    brews = [ ];
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      "iterm2"
      "wezterm-nightly"
      "wireshark"
    ];
  };

  # Set Git commit hash for darwin-version.
  # MAARI: Enable this later
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Enable TouchId for sudo
  security.pam.enableSudoTouchIdAuth = true;

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlay
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = config._module.specialArgs;
}

