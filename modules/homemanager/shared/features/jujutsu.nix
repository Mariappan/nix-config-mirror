{ pkgs, ... }:
{
  programs.jujutsu.enable = true;
  programs.jujutsu.settings = {
    ui = {
      paginate = "never";
      default-command = "log";
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
}
