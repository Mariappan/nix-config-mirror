{ pkgs, lib, ... }:
{
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
      "stash" = ["log" "-r" "stash() | parents(stash()) ~ stash()"];
    };
    revsets = {
      log = "(present(@) | ancestors(immutable_heads().. ~ stash(), 2) | trunk()) ~ stash()";
    };
    git = {
      private-commits = "private()";
    };
    revset-aliases = {
      "stash()" = "description(glob:\"stash:*\")";
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
}
