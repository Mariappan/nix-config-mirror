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
    };
    signing = {
      behavior = "drop";
      backend = "gpg";
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
  };

  home.packages = [
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    pkgs.meld
  ];
}
