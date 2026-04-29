{
  flake.modules.homeManager.jujutsu = { pkgs, lib, ... }: {
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
        "l" = ["log" "--limit" "30"];
        "lm" = ["log" "-r" "mutable()"];
        "lb" = ["log" "-r" "descendants(main..@)"];
        # This is better
        "mine" = ["log" "-r" "reachable(@, mutable())"];
        "rebase-all" = ["rebase" "-s" "all:mutable() & ~trunk()" "-d" "trunk()"];
        "stash" = ["util" "exec" "--" "bash" "-c" ''
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
            *)
              g="description(glob:\"stash($1):*\")"
              jj log -r "$g | parents($g) ~ stash()"
              ;;
          esac
        '' ""];
        "diffr" = ["util" "exec" "--" "bash" "-c" ''jj diff --from "$1@origin" --to "$1" --git'' ""];
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
        revision_command = ["show" "--git" "--stat" "--color" "always" "-r" "$change_id"];
      };
    };

    home.packages = [
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.meld
    ];
  };
}
