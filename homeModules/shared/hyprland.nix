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
      mainbar = {
        margin = "20 20 0 20";
        modules-left = ["hyprland/workspaces" "keyboard-state"];
        modules-center = ["clock" "custom/weather"];
        modules-right = ["pulseaudio" "custom/notification" "network" "custom/mem" "backlight" "battery" "tray" "custom/suspend"];

        "hyprland/workspaces" = {
          "disable-scroll" = true;
          "show-special" = false;
          "all-outputs" = true;
          "special-visible-only" = true;
          "persistent-workspaces" = {
            "eDP-1" = [1 2 3 4 5];
            "DP-2" = [1 2 3 4 5];
            "DP-3" = [1 2 3 4 5];
            "DP-4" = [1 2 3 4 5];
          };
        };

        "custom/notification" = {
          "tooltip" = false;
          "format" = "{icon}";
          "format-icons" = {
            "notification" = "<span font-weight='bold'>﨧</span>";
            "none" = "逸";
            "dnd-notification" = "﨧<span foreground='red'><sup></sup></span>";
            "dnd-none" = "﨧";
            "inhibited-notification" = "逸<span foreground='red'><sup></sup></span>";
            "inhibited-none" = "逸";
            "dnd-inhibited-notification" = "﨧<span foreground='red'><sup></sup></span>";
            "dnd-inhibited-none" = "﨧";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          "exec" = "swaync-client -swb";
          "on-click" = "swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          "escape" = true;
        };

        "keyboard-state" = {
          "capslock" = true;
          "format" = "{icon}";
          "format-icons" = {
            "locked" = "";
            "unlocked" = "";
          };
        };

        "custom/suspend" = {
          "format" = "襤";
          "on-click" = "systemctl suspend";
          "signal" = 9;
          "tooltip" = false;
        };

        "hyprland/mode" = {
          "format" = "<span style=\"italic\">{}</span>";
        };

        "network" = {
          "interface" = "wlp0s20f3";
          "format-wifi" = "{essid} ({signalStrength}%) 直";
          "format-disconnected" = "Disabled 睊";
          "tooltip-format-wifi" = "{essid} ({signalStrength}%) 直";
          "tooltip-format-disconnected" = "Disconnected";
          on-click = pkgs.writeShellScript "waybar_toggle_wifi.sh" ''
            ${builtins.readFile ../dotfiles/waybar/scripts/toggle_wifi.sh}
          '';
          "max-length" = 50;
        };

        "clock" = {
          "timezone" = "Asia/Singapore";
          "tooltip-format" = "<big>{ =%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format" = "{ =%a, %d %b, %I =%M %p}";
        };

        "custom/weather" = {
          "format" = "{}";
          "tooltip" = true;
          "interval" = 1800;
          exec =
            pkgs.writers.writePython3 "waybar_wttr.py" {
              flakeIgnore = ["E501" "F541" "E226" "W391" "E722" "E225" "E265" "E302"];
            } ''
              ${builtins.readFile ../dotfiles/waybar/scripts/wttr.py}
            '';
          "exec-on-event" = true;
          "on-click" = "exit 0";
          "return-type" = "json";
        };

        "pulseaudio" = {
          "reverse-scrolling" = 1;
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = "婢 {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["奄" "奔" "墳"];
          };
          "on-click" = "pavucontrol";
          "min-length" = 13;
        };

        "custom/mem" = {
          "format" = "{} ";
          "interval" = 3;
          "exec" = "free -h | awk '/Mem =/{printf $3}'";
          "tooltip" = false;
        };

        "temperature" = {
          "critical-threshold" = 80;
          "format" = "{temperatureC}°C {icon}";
          "format-icons" = ["" "" "" "" ""];
          "tooltip" = false;
        };

        "backlight" = {
          "tooltip" = false;
          "device" = "intel_backlight";
          "format" = "{percent}% {icon}";
          "format-icons" = ["" "" "" "" "" "" ""];
        };

        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-icons" = ["" "" "" "" "" "" "" "" "" ""];
        };

        "tray" = {
          "icon-size" = 16;
          "spacing" = 0;
        };
      };
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
