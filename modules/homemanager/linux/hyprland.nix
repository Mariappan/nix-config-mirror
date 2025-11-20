{
  config,
  pkgs,
  lib,
  dotfilesPath,
  ...
}:
{
  # Enable related features
  nixma.hm.linux.wayland.enable = true;
  nixma.hm.linux.wayland.kanshi.enable = true;
  nixma.hm.linux.ghostty.enable = true;
  nixma.hm.linux.hypridle.enable = true;
  nixma.hm.linux.hyprlock.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    # Enable it for debug
    # package = pkgs.hyprland.override {
    #   debug = true;
    # };
    xwayland.enable = true;
    plugins = [ pkgs.hyprlandPlugins.hy3 ];

    extraConfig = ''
      ${builtins.readFile (dotfilesPath + "/hypr/hyprland.conf")}
    '';

    # Not needed since we have `programs.hyprland.withUWSM = true`
    # enable hyprland-session.target on hyprland startup
    # systemd.enable = true;
    # systemd.enableXdgAutostart = true;
    # systemd.variables = [ "XDG_SESSION_DESKTOP" ];
  };
  xdg.configFile.hyprland_configs = {
    source = dotfilesPath + "/hypr/hyprland";
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
    pkgs.hyprlandPlugins.hy3
    pkgs.hyprpicker
    pkgs.hyprlockfix
  ];
}
