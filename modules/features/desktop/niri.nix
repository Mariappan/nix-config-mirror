{ self, inputs, ... }:
{
  flake.modules.nixos.niri =
    { ... }:
    {
      imports = [ self.modules.nixos.wayland ];

      # niri HM module is imported via user's hmModules, not sharedModules,
      # to avoid leaking desktop config to root user

      programs.niri.enable = true;

      xdg.terminal-exec.settings = {
        niri = [
          "com.mitchellh.ghostty"
        ];
        niri-session = [
          "com.mitchellh.ghostty"
        ];
      };

      # Add session variables manually.
      # Will be set by uwsm in Hyprland
      environment.sessionVariables = {
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "niri";
        XDG_CURRENT_DESKTOP = "niri";
      };
    };

  flake.modules.homeManager.niri =
    { ... }:
    {
      imports = [
        inputs.niri.homeModules.niri
        self.modules.homeManager.wayland
        self.modules.homeManager.stasis
        self.modules.homeManager.kanshi
        self.modules.homeManager.hyprlock
        self.modules.homeManager.ghostty
        self.modules.homeManager.dconf
        self.modules.homeManager.noctalia
      ];

      programs.niri.enable = true;

      # Polkit for auth
      services.polkit-gnome.enable = true;

      # Portal for xdg-open
      xdg.portal = {
        config = {
          niri = {
            default = [
              "gtk"
              "gnome"
            ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            "org.freedesktop.portal.FileChooser" = [ "xdg-desktop-portal-gtk" ];
          };
        };
      };
    };
}
