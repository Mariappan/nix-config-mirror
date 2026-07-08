{
  flake.modules.homeManager.gcroot-keepwarm =
    { pkgs, ... }:
    {
      nixma.imported.gcroot-keepwarm = true;

      # nh-clean.timer runs `nh clean all --keep-since 30d` weekly (see
      # modules/base/nix-settings.nix), which prunes gcroots by mtime. Project
      # gcroots pinned in ~/.local/state/gcroots/ (e.g. a devenv shell/venv
      # you haven't opened in a while) would otherwise age out and get GC'd.
      # Touch every file in that dir weekly, before nh-clean runs, so pins
      # never look stale. Add new gcroots there with:
      #   nix build --out-link ~/.local/state/gcroots/<name> <store-path>
      systemd.user.services.gcroot-keepwarm = {
        Unit.Description = "Touch pinned gcroots so nh-clean --keep-since doesn't reap them";
        Service = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "gcroot-keepwarm" ''
            dir="$HOME/.local/state/gcroots"
            mkdir -p "$dir"
            find "$dir" -mindepth 1 -maxdepth 1 -exec touch -h -- {} +
          '';
        };
      };

      systemd.user.timers.gcroot-keepwarm = {
        Unit.Description = "Weekly refresh of pinned gcroots (runs before nh-clean.timer)";
        Timer = {
          OnCalendar = "Sun *-*-* 12:00:00";
          Persistent = true;
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
}
