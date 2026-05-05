{ self, ... }:
{
  flake.modules.homeManager.stasis =
    { pkgs, ... }:
    let
      systemdTarget = "graphical-session.target";
    in
    {
      nixma.imported.stasis = true;

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

      xdg.configFile."stasis".source = self + /dotfiles/stasis;

      home.packages = [
        pkgs.stasis
      ];
    };
}
