{
  pkgs,
  config,
  lib,
  inputs,
  outputs,
  home-manager,
  ...
}:
{
  imports = [
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = config._module.specialArgs;
      home-manager.backupFileExtension = "backup";
    }
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

  # Disable nix-darwin nix management. Determindated nixd will take care of it
  nix.enable = false;

  # Not needed for determinate nix
  # nix.settings.experimental-features = "nix-command flakes";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.curl
    pkgs.pinentry_mac
    pkgs.terminal-notifier
  ];

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
