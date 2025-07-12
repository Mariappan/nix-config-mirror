{ pkgs, inputs, ... }: {

  home.packages = [
    pkgs.caelestia-shell
    pkgs.caelestia-cli
  ];

  xdg.configFile.app2unit_env = {
    enable = true;
    target = "environment.d/999-app2unit.conf";
    text = "APP2UNIT_SLICES='a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice'\n";
  };

  # Systemd service
  systemd.user.services.caelestia-shell = {
    Unit = {
      Description = "Caelestia desktop shell";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "exec";
      ExecStart = "${pkgs.caelestia-shell}/bin/caelestia-shell";
      Restart = "on-failure";
      Slice = "app-graphical.slice";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
