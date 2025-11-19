{ ... }:
{
  services.hypridle.enable = true;
  services.hypridle.settings = {
    general = {
      lock_cmd = "caelestia shell lock lock";
      before_sleep_cmd = "caelestia shell lock lock";
      after_sleep_cmd = "hyprctl dispatch dpms on";
      ignore_dbus_inhibit = false;
    };

    listener = [
      {
        timeout = 180;
        on-timeout = "caelestia shell lock lock";
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
