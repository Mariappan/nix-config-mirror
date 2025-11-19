{ pkgs, ... }:
let
  systemdTarget = "graphical-session.target";
  swwwSystemdService = "swww.service";
in
{
  systemd.user.services.swww = {
    Unit = {
      Description = "Wallpaper manager";
      Documentation = "man:swww(1)";
      PartOf = systemdTarget;
      Requires = systemdTarget;
      After = systemdTarget;
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      Restart = "always";
    };

    Install = {
      WantedBy = [ systemdTarget ];
    };
  };

  systemd.user.services.swww-wallpaper = {
    Unit = {
      Description = "Set Wallpaper";
      Documentation = "man:swww(1)";
      Requires = swwwSystemdService;
      After = swwwSystemdService;
    };

    Service = {
      Type = "oneshot";
      ExecStartPre = "sleep 2";
      ExecStart = "${pkgs.swww}/bin/swww img %h/pictures/wallpaper.jpg";
    };

    Install = {
      WantedBy = [ swwwSystemdService ];
    };
  };

  home.packages = [
    pkgs.swww
  ];
}
