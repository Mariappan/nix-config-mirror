{ pkgs, ... }:
let
  systemdTarget = "graphical-session.target";
in
{
  systemd.user.services.stasis = {
    Unit = {
      Description = "Stasis Wayland Idle Manager";
      PartOf = systemdTarget;
      Requires = systemdTarget;
      After = systemdTarget;
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.stasis}/bin/stasis";
      Restart = "always";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ systemdTarget ];
    };
  };

  home.packages = [
    pkgs.stasis
  ];
}
