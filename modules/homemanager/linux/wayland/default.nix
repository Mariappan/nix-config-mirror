{
  pkgs,
  ...
}:
{
  # Enable related features
  nixma.hm.linux.ghostty.enable = true;
  nixma.hm.linux.foot.enable = true;
  nixma.hm.linux.wayland.media-viewer.enable = true;
  nixma.hm.linux.wayland.udiskie.enable = true;
  nixma.hm.linux.wayland.satty.enable = true;

  xdg.configFile.wayland_env = {
    enable = true;
    target = "environment.d/999-wayland.conf";
    text = ''
      NIXOS_OZONE_WL = '1'
      WLR_NO_HARDWARE_CURSORS = '1'
    '';
  };

  xdg.configFile.app2unit_env = {
    enable = true;
    target = "environment.d/999-app2unit.conf";
    text = "APP2UNIT_SLICES='a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice'\n";
  };

  gtk = {
    enable = true;
    cursorTheme.name = "Adwaita";
    cursorTheme.package = pkgs.adwaita-icon-theme;
    theme.name = "adw-gtk3-dark";
    theme.package = pkgs.adw-gtk3;
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
    pkgs.nixma.cthulock

    pkgs.app2unit

    # UI Tools
    pkgs.qpdf
    pkgs.nautilus
  ];
}
