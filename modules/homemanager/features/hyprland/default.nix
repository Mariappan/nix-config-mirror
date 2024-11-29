{pkgs, ...}: {
  imports = [
    ./anyrun.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./kanshi.nix
    ./swaync.nix
    ./waybar.nix
    ./swww.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # Enable it for debug
    # package = pkgs.hyprland.override {
    #   debug = true;
    # };
    xwayland.enable = true;
    plugins = [pkgs.hyprlandPlugins.hy3];

    extraConfig = ''
      ${builtins.readFile ../../../../dotfiles/hypr/hyprland.conf}
    '';

    # enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };

  programs.imv.enable = true;

  xdg.configFile = {
    "wlr-which-key" = {
      source = ../../../../dotfiles/wlr-which-key-config.yaml;
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

  services.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "xdph"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        "org.freedesktop.portal.FileChooser" = ["xdg-desktop-portal-gtk"];
      };
    };
    extraPortals = with pkgs; [xdg-desktop-portal-hyprland xdg-desktop-portal-gtk];
  };

  home.packages = [
    pkgs.hyprlandPlugins.hy3

    # Screenshot utility
    pkgs.hyprshot
    pkgs.slurp

    pkgs.hyprpicker
    pkgs.ianny
    pkgs.wl-clipboard

    pkgs.wlr-which-key

    # Screenshot utility
    pkgs.wf-recorder

    pkgs.wtype
    pkgs.wayprompt
  ];
}
