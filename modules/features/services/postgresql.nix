# Generic, host-agnostic PostgreSQL server + logical backups.
{
  flake.modules.nixos.postgresql =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.nixma.nixos.postgresql;

      # Dump-all-databases script, parameterised by target subdir + prune args.
      # Runs as the `postgres` superuser so peer auth over the socket just works.
      mkDumpScript = subdir: pruneArgs: ''
        set -euo pipefail
        dest='${cfg.backup.dir}/${subdir}'
        mkdir -p "$dest"
        stamp=$(date +%Y%m%d-%H%M%S)

        # Roles, grants, tablespaces — everything pg_dump omits.
        pg_dumpall --globals-only > "$dest/globals-$stamp.sql"

        # One custom-format dump per real database (selective restore later).
        for db in $(psql -At -c \
          "SELECT datname FROM pg_database WHERE datistemplate = false AND datname <> 'postgres';"); do
          pg_dump -Fc "$db" > "$dest/$db-$stamp.dump"
        done

        # Prune old dumps. Guarded by RequiresMountsFor so this never runs on an
        # unmounted backup pool (which would delete nothing / write to root fs).
        find "$dest" -type f \( -name '*.dump' -o -name 'globals-*.sql' \) ${pruneArgs} -delete
      '';

      mkBackupService = subdir: pruneArgs: {
        description = "PostgreSQL logical backup (${subdir}) to ${cfg.backup.dir}/${subdir}";
        # Don't dump into an empty mountpoint if the backup pool isn't up yet.
        unitConfig.RequiresMountsFor = [ cfg.backup.dir ];
        after = [ "postgresql.service" ];
        requires = [ "postgresql.service" ];
        path = [
          config.services.postgresql.package
          pkgs.coreutils
          pkgs.findutils
        ];
        serviceConfig = {
          Type = "oneshot";
          User = "postgres";
          Group = "postgres";
        };
        script = mkDumpScript subdir pruneArgs;
      };
    in
    {
      options.nixma.nixos.postgresql = {
        dataDir = lib.mkOption {
          type = lib.types.str;
          default = "/var/lib/postgresql";
          description = ''
            Parent directory PostgreSQL stores its cluster under. A `RequiresMountsFor`
            guard is added so postgres waits for this path's mount (e.g. a dedicated
            fast ZFS dataset). The per-version cluster lives in `''${dataDir}/<version>`.
          '';
        };

        backup = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable periodic logical backups (pg_dump) of all databases.";
          };

          dir = lib.mkOption {
            type = lib.types.str;
            example = "/srv/postgres-backups";
            description = "Target directory for dumps. Put it on a different pool than the live data.";
          };

          hourlyRetention = lib.mkOption {
            type = lib.types.ints.positive;
            default = 24;
            description = "How many hours of hourly dumps to keep.";
          };

          dailyRetentionDays = lib.mkOption {
            type = lib.types.ints.positive;
            default = 7;
            description = "How many days of daily dumps to keep.";
          };
        };
      };

      config = {
        nixma.nixos.imported.postgresql = true;

        services.postgresql.enable = true;

        systemd.services = lib.mkMerge [
          # Wait for the (possibly dedicated) data pool before starting.
          { postgresql.unitConfig.RequiresMountsFor = [ cfg.dataDir ]; }
          (lib.mkIf cfg.backup.enable {
            postgresql-backup-hourly = mkBackupService "hourly" "-mmin +${toString (cfg.backup.hourlyRetention * 60)}";
            postgresql-backup-daily = mkBackupService "daily" "-mtime +${toString cfg.backup.dailyRetentionDays}";
          })
        ];

        systemd.timers = lib.mkIf cfg.backup.enable {
          postgresql-backup-hourly = {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = "hourly";
              Persistent = true;
            };
          };
          postgresql-backup-daily = {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = "daily";
              Persistent = true;
            };
          };
        };
      };
    };
}
