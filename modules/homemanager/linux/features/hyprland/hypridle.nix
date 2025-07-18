{
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
        timeout = 280;
        on-timeout = "systemctl --user stop app-io.github.slgobinath.SafeEyes@autostart.service";
        on-resume = "systemctl --user start app-io.github.slgobinath.SafeEyes@autostart.service";
      }
      {
        timeout = 290;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      {
        timeout = 300;
        on-timeout = "[ \"$(cat /sys/class/power_supply/AC/online)\" = \"0\" ] && systemctl suspend";
      }
    ];
  };
}
