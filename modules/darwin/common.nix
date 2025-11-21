{
  pkgs,
  config,
  outputs,
  home-manager,
  ...
}:
{
  imports = [
    home-manager.darwinModules.home-manager
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

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = config._module.specialArgs;
  home-manager.backupFileExtension = "backup";

  # Create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;
  programs.fish.enable = true;

  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    nix-direnv.enable = true;
    silent = true;
  };

  environment.shells = [
    pkgs.zsh
    pkgs.fish
  ];

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

  fonts.packages = with pkgs; [
    # Maple Mono (Ligature TTF unhinted)
    maple-mono.truetype
    # MesloLGS NF font
    nixma.meslolgsnf-font
    # Script12 BT font with custom sizing
    nixma.script12bt-font
  ];

  # Enable TouchId for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
