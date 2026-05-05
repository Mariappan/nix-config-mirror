{ self, inputs, ... }:
{
  flake.modules.darwin.common =
    { pkgs, ... }:
    {
      imports = [
        self.modules.darwin.shared-nixpkgs
        self.modules.darwin.shared-homemanager
        self.modules.darwin.shared-shells
        self.modules.darwin.shared-fonts
        self.modules.darwin.profile
      ];

      nixma.darwin.imported.common = true;

      # Darwin hosts are always workstations — load workstation HM modules.
      home-manager.sharedModules = [
        self.modules.homeManager.desktop
        self.modules.homeManager.helix
        inputs.nix-index-database.homeModules.nix-index
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
    };
}
