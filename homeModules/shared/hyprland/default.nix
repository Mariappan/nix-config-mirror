{pkgs, ...}: {
  imports = [
    ./anyrun.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./kanshi.nix
    ./swaync.nix
    ./waybar.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    plugins = [ pkgs.hyprlandPlugins.hy3 ];

    extraConfig = ''
      ${builtins.readFile ../../dotfiles/hypr/hyprland.conf}
    '';

    # enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };

  programs.imv.enable = true;

  xdg.configFile = {
    "wlr-which-key" = {
      source = ../../dotfiles/wlr-which-key-config.yaml;
      target = "wlr-which-key/config.yaml";
    };
  };

  home.packages = [
    pkgs.hyprlandPlugins.hy3

    pkgs.hyprpicker
    pkgs.ianny
    pkgs.swww
    pkgs.wl-clipboard

    pkgs.wlr-which-key

    # Screenshot utility
    pkgs.slurp
    pkgs.grim

    # Screenshot utility
    pkgs.wf-recorder

    pkgs.wtype
    pkgs.wayprompt
  ];
}
