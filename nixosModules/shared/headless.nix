{lib, ...}: {
  boot.kernelParams = [
    # when there's an issue, we want the server to reboot, not hang
    "panic=10"
    "boot.panic_on_fail"
    "oops=panic"
  ];

  powerManagement.enable = lib.mkDefault false;

  # Without this, systemd-logind will eat 1 full CPU
  # https://discussion.fedoraproject.org/t/systemd-logind-eats-cpu-when-closing-laptop-lid/67805/3
  services.logind.lidSwitch = lib.mkDefault "ignore";

  services.xserver.displayManager.gdm.autoSuspend = false;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.login1.suspend" ||
        action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
        action.id == "org.freedesktop.login1.hibernate" ||
        action.id == "org.freedesktop.login1.hibernate-multiple-sessions") {
          return polkit.Result.NO;
      }
    })
  '';

  services.xserver.desktopManager.gnome = {
    extraGSettingsOverrides = ''
      [org.gnome.settings-daemon.plugins.power]
      power-button-action='nothing'
      idle-dim=true
      sleep-inactive-battery-type='nothing'
      sleep-inactive-battery-type=1800
      sleep-inactive-ac-type='nothing'
      sleep-inactive-ac-timeout=0
    '';
  };

  systemd = {
    targets = {
      sleep = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      suspend = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      hibernate = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      "hybrid-sleep" = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
    };
  };
}
