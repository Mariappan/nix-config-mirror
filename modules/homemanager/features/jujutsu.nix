{ pkgs, lib, ... }:
{
  programs.jujutsu.enable = true;

  xdg.configFile."oyo/config.toml".text = ''
    [ui.theme]
    name = "everforest"
    mode = "dark"

    [ui.syntax]
    mode = "on"
    theme = "everforest"
  '';

  programs.jujutsu.settings = {
    ui = {
      editor = "hx";
      paginate = "never";
      default-command = "log";
      diff-formatter = [ "oy" "$left" "$right" ];
    };
    diff-tools.oy = {
      command = [ "oy" "$left" "$right" ];
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

  home.packages = [
    pkgs.lazyjj
    pkgs.nixma.oyo
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    pkgs.meld
  ];
}
