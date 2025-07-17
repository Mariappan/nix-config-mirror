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

  programs.imv.enable = true;

  xdg.configFile = {
    "wlr-which-key" = {
      source = ../../../../../dotfiles/wlr-which-key-config.yaml;
      target = "wlr-which-key/config.yaml";
    };
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

  home.packages = [
    pkgs.hyprlandPlugins.hy3

    # Screenshot utility
    pkgs.hyprshot
    pkgs.slurp

    pkgs.hyprpicker
    pkgs.wl-clipboard

    pkgs.wlr-which-key

    # Screenshot utility
    pkgs.wf-recorder

    pkgs.wtype
    pkgs.wayprompt
  ];
}
