{
  pkgs,
  config,
  lib,
  inputs,
  home-manager,
  ...
}: {
  imports = [
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = config._module.specialArgs;
      home-manager.backupFileExtension = "backup";
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
  nix.settings.experimental-features = "nix-command flakes";

  nix.gc = {
    user = "root";
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 2;
      Minute = 0;
    };
    options = "--delete-older-than 7d";
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.curl
    pkgs.openssh
    pkgs.pinentry_mac
    pkgs.vim
  ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;

  programs.direnv.enable = true;
  programs.direnv.loadInNixShell = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.silent = false;

  environment.shells = [pkgs.bashInteractive pkgs.zsh pkgs.fish];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = ["homebrew/cask-versions"];
    brews = ["m4" "autoconf" "automake" "cmake" "git-lfs" "libtool"];
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      "arc"
      "boop"
      "iterm2"
      "obsidian"
      "vlc"
      "visual-studio-code"
      "wezterm-nightly"
      "wireshark"
    ];
  };

  # Enable TouchId for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
