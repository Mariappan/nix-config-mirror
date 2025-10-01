{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./kanshi.nix
    ../ghostty.nix
    ../foot.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # Enable it for debug
    # package = pkgs.hyprland.override {
    #   debug = true;
    # };
    xwayland.enable = true;
    plugins = [ pkgs.hyprlandPlugins.hy3 ];

    extraConfig = ''
      ${builtins.readFile ../../../../../dotfiles/hypr/hyprland.conf}
    '';

    # Not needed since we have `programs.hyprland.withUWSM = true`
    # enable hyprland-session.target on hyprland startup
    # systemd.enable = true;
    # systemd.enableXdgAutostart = true;
    # systemd.variables = [ "XDG_SESSION_DESKTOP" ];
  };
  xdg.configFile.hyprland_configs = {
    source = ../../../../../dotfiles/hypr/hyprland;
    target = "hypr/hyprland";
  };

  xdg.configFile = {
    "wlr-which-key" = {
      source = ../../../../../dotfiles/wlr-which-key-config.yaml;
      target = "wlr-which-key/config.yaml";
    };
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

  home.activation = {
    hyprlandAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run touch $HOME/.config/hypr/hyprland_after.conf
    '';
  };

  services.gnome-keyring.enable = true;
  services.hyprpolkitagent.enable = true;

  services.udiskie.enable = true;

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "xdph"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.portal.FileChooser" = [ "xdg-desktop-portal-gtk" ];
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  xdg.configFile.wayland_env = {
    enable = true;
    target = "environment.d/999-wayland.conf";
    text = ''
      NIXOS_OZONE_WL = '1'
      WLR_NO_HARDWARE_CURSORS = '1'
    '';
  };

  programs.mpv.enable = true;
  programs.imv.enable = true;

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "default-web-browser" = "vivaldi-stable.desktop";
    "image/*" = "imv.desktop";
    "image/gif" = "imv.desktop";
    "text/html" = "neovide.desktop";
    "application/pdf" = "vivaldi-stable.desktop";
    "application/rdf+xml" = "vivaldi-stable.desktop";
    "application/rss+xml" = "vivaldi-stable.desktop";
    "application/xhtml+xml" = "vivaldi-stable.desktop";
    "application/xhtml_xml" = "vivaldi-stable.desktop";
    "application/xml" = "vivaldi-stable.desktop";
    "x-scheme-handler/http" = "vivaldi-stable.desktop";
    "x-scheme-handler/https" = "vivaldi-stable.desktop";
    "x-scheme-handler/about" = "vivaldi-stable.desktop";
    "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
  };

  home.packages = [
    pkgs.wl-clipboard

    pkgs.hyprlandPlugins.hy3

    pkgs.hyprpicker
    pkgs.wlr-which-key

    # Screenshot utility
    pkgs.wf-recorder

    pkgs.wtype
    pkgs.wayprompt

    pkgs.hyprlockfix
    pkgs.brightnessctl
  ];
}
