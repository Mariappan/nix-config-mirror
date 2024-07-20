{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hyprland_anyrun.nix
  ];

  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    extraConfig = ''
      ${builtins.readFile ../dotfiles/hypr/hyprland.conf}
    '';

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };

  programs.hyprlock = {
    enable = true;
    extraConfig = ''
      ${builtins.readFile ../dotfiles/hypr/hyprlock.conf}
    '';
  };
  programs.imv.enable = true;

  programs.waybar = {
    enable = true;
    settings = {
      mainbar = builtins.fromJSON (builtins.readFile ../dotfiles/waybar/config);
    };
    style = ''
      ${builtins.readFile ../dotfiles/waybar/style.css}
    '';

    systemd.enable = true;
    systemd.target = "hyprland-session.target";
  };

  services.hypridle.enable = true;
  services.hypridle.settings = {
    general = {
      lock_cmd = "hyprlock";
      before_sleep_cmd = "hyprlock";
      after_sleep_cmd = "hyprctl dispatch dpms on";
      ignore_dbus_inhibit = false;
    };

    listener = [
      {
        timeout = 180;
        on-timeout = "hyprlock";
      }
      {
        timeout = 290;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      {
        timeout = 300;
        on-timeout = "systemctl suspend";
      }
    ];
  };

  services.swaync = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ../dotfiles/swaync/config.json);
    style = ''
      ${builtins.readFile ../dotfiles/swaync/style.css}
    '';
  };

  home.packages = [
    pkgs.hyprpicker
    pkgs.ianny
    pkgs.swww
    pkgs.wl-clipboard

    # Screenshot utility
    pkgs.slurp
    pkgs.grim

    # Screenshot utility
    pkgs.wf-recorder

    pkgs.wtype
    pkgs.wayprompt
  ];
}
