{ self, ... }:
{
  flake.modules.nixos.hyprland =
    { ... }:
    {
      imports = [ self.modules.nixos.wayland ];

      # hyprland HM module is imported via user's hmModules, not sharedModules,
      # to avoid leaking desktop config to root user

      programs.hyprland.enable = true;
      programs.hyprland.withUWSM = true;
      # Enable it for debug package
      # programs.hyprland.package = pkgs.hyprland.override {
      #   debug = true;
      # };
      programs.wshowkeys.enable = true;

      xdg.terminal-exec.settings = {
        Hyprland = [
          "com.mitchellh.ghostty"
        ];
      };
    };

  flake.modules.homeManager.hyprland =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        self.modules.homeManager.wayland
        self.modules.homeManager.kanshi
        self.modules.homeManager.ghostty
        self.modules.homeManager.hypridle
        self.modules.homeManager.hyprlock
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        # Enable it for debug
        # package = pkgs.hyprland.override {
        #   debug = true;
        # };
        xwayland.enable = true;
        plugins = [ ];

        extraConfig = ''
          ${builtins.readFile (self + /dotfiles/hypr/hyprland.conf)}
        '';

        # Not needed since we have `programs.hyprland.withUWSM = true`
        # enable hyprland-session.target on hyprland startup
        # systemd.enable = true;
        # systemd.enableXdgAutostart = true;
        # systemd.variables = [ "XDG_SESSION_DESKTOP" ];
      };
      xdg.configFile.hyprland_configs = {
        source = self + /dotfiles/hypr/hyprland;
        target = "hypr/hyprland";
      };

      home.activation = {
        hyprlandAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run touch $HOME/.config/hypr/hyprland_after.conf
        '';
      };

      services.hyprpolkitagent.enable = true;

      xdg.portal = {
        config = {
          Hyprland = {
            default = [
              "xdph"
              "gtk"
              "gnome"
            ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            "org.freedesktop.portal.FileChooser" = [ "xdg-desktop-portal-gtk" ];
          };
        };
      };

      home.packages = [
        pkgs.hyprpicker
        pkgs.hyprlockfix
      ];
    };
}
