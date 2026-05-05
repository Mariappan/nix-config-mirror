{
  flake.modules.homeManager.jujutsu =
    {
      pkgs,
      lib,
      osConfig,
      ...
    }:
    {
      nixma.imported.jujutsu = true;

      programs.jujutsu.enable = true;
      programs.jujutsu.settings = {
        ui = {
          editor = "hx";
          paginate = "never";
          default-command = "log";
          diff-formatter = [
            "difft"
            "--color=always"
            "$left"
            "$right"
          ];
          show-cryptographic-signatures = true;
        };
        signing = {
          behavior = "drop";
          backend = "gpg";
        };
        aliases = {
          "l" = [
            "log"
            "--limit"
            "30"
          ];
          "lm" = [
            "log"
            "-r"
            "mutable()"
          ];
          "lb" = [
            "log"
            "-r"
            "descendants(main..@)"
          ];
          # This is better
          "mine" = [
            "log"
            "-r"
            "reachable(@, mutable())"
          ];
          "rebase-all" = [
            "rebase"
            "-s"
            "all:mutable() & ~trunk()"
            "-d"
            "trunk()"
          ];
          "stash" = [
            "util"
            "exec"
            "--"
            "bash"
            "-c"
            ''
              rewrite_descs() {
                local revset="$1" sed_expr="$2" filter="$3"
                jj log -r "$revset" --no-graph -T 'change_id.short() ++ "\n"' \
                  | while read -r id; do
                      desc=$(jj log -r "$id" --no-graph -T description)
                      if [ -n "$filter" ] && ! eval "$filter"; then continue; fi
                      new_desc=$(printf '%s' "$desc" | sed -E "$sed_expr")
                      if [ "$desc" != "$new_desc" ]; then
                        jj describe -r "$id" -m "$new_desc" --quiet
                      fi
                    done
              }
              case "''${1:-}" in
                "")
                  u='description(glob:"stash:*")'
                  jj log -r "$u | parents($u) ~ stash()"
                  ;;
                --all|-a)
                  jj log -r 'stash() | parents(stash()) ~ stash()'
                  ;;
                --groups)
                  jj log -r 'description(glob:"stash(*):*")' --no-graph \
                    -T 'description.first_line() ++ "\n"' \
                    | sed -nE 's/^stash\(([^)]+)\):.*/\1/p' | sort -u
                  ;;
                add)
                  if [ -z "''${2:-}" ] || [ -z "''${3:-}" ]; then
                    echo "usage: jj stash add <revset> <scope>" >&2; exit 1
                  fi
                  rewrite_descs "$2" "1 s|^|stash($3): |" \
                    'case "$desc" in stash:*|"stash("*"):"*|"") false ;; *) true ;; esac'
                  ;;
                drop)
                  if [ -z "''${2:-}" ]; then
                    echo "usage: jj stash drop <revset>" >&2; exit 1
                  fi
                  rewrite_descs "$2" '1 s|^stash(\([^)]*\))?:[[:space:]]*||' '''
                  ;;
                rewrite)
                  if [ -z "''${2:-}" ] || [ -z "''${3:-}" ]; then
                    echo "usage: jj stash rewrite <revset> <scope>" >&2; exit 1
                  fi
                  rewrite_descs "$2" "1 s|^stash(\\([^)]*\\))?:[[:space:]]*|stash($3): |" '''
                  ;;
                *)
                  g="description(glob:\"stash($1):*\")"
                  jj log -r "$g | parents($g) ~ stash()"
                  ;;
              esac
            ''
            ""
          ];
          "diffr" = [
            "util"
            "exec"
            "--"
            "bash"
            "-c"
            ''jj diff --from "$1@origin" --to "$1" --git''
            ""
          ];
        };
        revsets = {
          log = "(present(@) | ancestors(immutable_heads().. ~ stash(), 2) | trunk()) ~ stash()";
        };
        git = {
          private-commits = "private()";
        };
        revset-aliases = {
          "stash()" = "description(glob:\"stash:*\") | description(glob:\"stash(*):*\")";
          "private()" = "mutable() & (description(glob:\"private:*\") | stash() | (empty() & ~merges()))";
        };
      };

      programs.jjui.enable = true;
      programs.jjui.settings = {
        ui.colors = {
          selected = {
            bg = "#003446";
            bold = true;
          };
        };
        preview = {
          revision_command = [
            "show"
            "--git"
            "--stat"
            "--color"
            "always"
            "-r"
            "$change_id"
          ];
        };
      };

      # meld gtk closure (~150 MiB) — workstation HM only.
      home.packages = lib.optional (builtins.elem "workstation" (
        osConfig.nixma.nixos.roles or [ ]
      )) pkgs.meld;
    };
}
