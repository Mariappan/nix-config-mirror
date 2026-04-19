{ self, ... }:
{
  flake.modules.nixos.wayland =
    { pkgs, lib, ... }:
    {
      imports = [
        self.modules.nixos.wayland-dm
        self.modules.nixos.nautilus
        self.modules.nixos.shared-fonts
      ];

      programs.dconf.enable = true;

      # Ref: https://www.reddit.com/r/NixOS/comments/171mexa/polkit_on_hyprland/
      services.gnome.gnome-keyring.enable = true;
      security.polkit.enable = true;

      services.udisks2.enable = true;

      # polkit 127's socket-activated helper runs with strict sandboxing that
      # blocks pam_u2f.so (ProtectHome=yes hides u2f_keys, PrivateDevices=yes
      # hides /dev/hidraw*). Relax just enough for YubiKey auth to work.
      # Ref: https://github.com/NixOS/nixpkgs/pull/486044
      systemd.services."polkit-agent-helper@".serviceConfig = {
        ProtectHome = lib.mkForce "read-only";
        PrivateDevices = lib.mkForce false;
        DeviceAllow = lib.mkForce [
          "/dev/null rw"
          "/dev/urandom r"
          "char-hidraw rw"
        ];
        StandardError = "journal";
      };

      security.pam.services = {
        # GreetD - regreet uses separate `greetd` PAM context
        # Disable Fingerprint/Yubikey for allowing to unlock Keyring
        greetd = {
          enableGnomeKeyring = true;
          u2fAuth = false;
          fprintAuth = false;
        };
        # noctalia-shell uses login pam context
        # for system-lock
        login = {
          enableGnomeKeyring = true;
        };
        cthulock = {
          unixAuth = true;
          u2fAuth = true;
        };
        hyprlock.u2fAuth = true;
        polkit-1.u2fAuth = true;
      };

      xdg.terminal-exec.enable = true;
      xdg.terminal-exec.settings = {
        default = [
          "com.mitchellh.ghostty"
          "org.wezfurlong.wezterm.desktop"
          "foot"
        ];
      };

      environment.systemPackages = [
        pkgs.libnotify
      ];
    };

  flake.modules.homeManager.wayland =
    { pkgs, ... }:
    {
      imports = [
        self.modules.homeManager.ghostty
        self.modules.homeManager.foot
        self.modules.homeManager.media-viewer
        self.modules.homeManager.udiskie
        self.modules.homeManager.satty
      ];

      xdg.configFile.app2unit_env = {
        enable = true;
        target = "environment.d/999-app2unit.conf";
        text = "APP2UNIT_SLICES='a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice'\n";
      };

      gtk = {
        enable = true;
        colorScheme = "dark";
        cursorTheme.name = "Adwaita";
        cursorTheme.package = pkgs.adwaita-icon-theme;
      };

      home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";

      services.gnome-keyring.enable = true;

      xdg.portal = {
        enable = true;
        config = {
          common = {
            default = [
              "gtk"
              "gnome"
            ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            "org.freedesktop.portal.FileChooser" = [ "xdg-desktop-portal-gtk" ];
          };
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
        ];
      };

      home.packages = [
        pkgs.wl-clipboard
        pkgs.wayprompt
        pkgs.wtype
        # Check wayland protocol support
        pkgs.waycheck

        pkgs.brightnessctl
        pkgs.app2unit

        # UI Tools
        pkgs.qpdf
        pkgs.nautilus
      ];
    };
}
