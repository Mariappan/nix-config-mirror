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
  };
}
