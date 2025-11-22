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

  # Disable nix-darwin nix management. Determindated nixd will take care of it
  nix.enable = false;
  # nix.settings.experimental-features = "nix-command flakes";
  # Enable x64 using rosetta
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  environment.systemPackages = [
    pkgs.curl
    pkgs.pinentry_mac
    pkgs.terminal-notifier
  ];

  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    nix-direnv.enable = true;
    silent = true;
  };

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
  system.stateVersion = 4;
}
