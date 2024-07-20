{
  pkgs,
  config,
  ...
}:
let
  pkg_togglewifi = pkgs.writeScriptBin "waybar_togwifi.sh" (builtins.readFile ../dotfiles/waybar/scripts/toggle_wifi.sh);
  pkg_wttrpy = pkgs.writers.writePython3Bin "waybar_wttr.py" {} (builtins.readFile ../dotfiles/waybar/scripts/wttr.py);
  togglewifi = "${pkg_togglewifi}/bin/waybar_togwifi.sh";
  wttrpy = "${pkg_wttrpy}/bin/waybar_wttr.py";
in
{
  imports = [
    ./hyprland_anyrun.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;

    extraConfig = ''
      ${builtins.readFile ../dotfiles/hypr/hyprland.conf}
    '';

    # enable hyprland-session.target on hyprland startup
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
      mainbar = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile (pkgs.substituteAll {
        src = ../dotfiles/waybar/config;
        inherit togglewifi wttrpy;
      })));
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

  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            scale = 1.0;
            status = "enable";
          }
        ];
      };

      home_office = {
        outputs = [
          {
            criteria = "Dell Inc. DELL U2724DE 1LRK7P3";
            position = "0,0";
            mode = "2560x1440@60Hz";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };
    };
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

    # Keep it so that it is not garbage collected
    pkg_togglewifi
    pkg_wttrpy
  ];
}
