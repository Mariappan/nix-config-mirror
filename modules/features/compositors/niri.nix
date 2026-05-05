{ self, inputs, ... }:
{
  flake.modules.nixos.niri =
    { ... }:
    {
      imports = [
        inputs.noctalia.nixosModules.default
        self.modules.nixos.wayland
        self.modules.nixos.veila
      ];

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
    { config, lib, ... }:
    {
      imports = [
        self.modules.homeManager.wayland
        self.modules.homeManager.stasis
        self.modules.homeManager.kanshi
        self.modules.homeManager.hyprlock
        self.modules.homeManager.ghostty
        self.modules.homeManager.dconf
        self.modules.homeManager.noctalia
        self.modules.homeManager.veila
      ];

      home.activation.niri-symlink =
        let
          dotfiles = "${config.dotfilesNonSandboxPath}/niri";
          target = "${config.xdg.configHome}/niri";
        in
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [[ -d ${target} && ! -L ${target} ]]; then
            run mv ${target} ${target}.pre-symlink
          fi
          run ln -sfn ${dotfiles} ${target}
        '';

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
