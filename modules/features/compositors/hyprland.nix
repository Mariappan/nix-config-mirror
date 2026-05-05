{ self, ... }:
{
  flake.modules.nixos.hyprland =
    { ... }:
    {
      imports = [ self.modules.nixos.wayland ];

      programs.hyprland.enable = true;
      programs.hyprland.withUWSM = true;
      # programs.hyprland.package = pkgs.hyprland.override { debug = true; };
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
        xwayland.enable = true;
        plugins = [ ];

        extraConfig = ''
          ${builtins.readFile (self + /dotfiles/hypr/hyprland.conf)}
        '';
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
