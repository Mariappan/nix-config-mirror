{ pkgs, inputs, ... }: {

  home.packages = [
    pkgs.caelestia-shell-with-cli
  ];

  xdg.configFile = {
    "caelestia" = {
      source = ../../../../dotfiles/caelestia-shell.json;
      target = "caelestia/shell.json";
    };
  };

  # Systemd service
  systemd.user.services.caelestia-shell = {
    Unit = {
      Description = "Caelestia desktop shell";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "exec";
      ExecStart = "${pkgs.caelestia-shell-with-cli}/bin/caelestia-shell";
      Restart = "on-failure";
      Slice = "app-graphical.slice";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
