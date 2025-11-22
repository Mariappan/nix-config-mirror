{
  pkgs,
  home-manager,
  ...
}:
{
  imports = [
    home-manager.darwinModules.home-manager
    ../shared/nixpkgs.nix
    ../shared/homemanager.nix
    ../shared/shells.nix
    ../shared/fonts.nix
  ];

  # Should not be hardcoded. But I am not gonna buy x64 macbook anytime
  # So this is fine for now
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Determindated nixd will take care of it
  nix.enable = false;

  environment.systemPackages = [
    pkgs.curl
    pkgs.pinentry_mac
    pkgs.terminal-notifier
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    brews = [ ];
    casks = [
      "boop"
      "obsidian"
      "vlc"
      "visual-studio-code"
      "wireshark-app"
    ];
  };

  # Enable TouchId for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
