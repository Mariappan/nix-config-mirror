{ pkgs, ... }: {

  programs.caelestia = {
    enable = true;
    package = pkgs.caelestia-shell;
    extraConfig = builtins.readFile ../../../../dotfiles/caelestia/shell.json;
    cli = {
      enable = true;
      extraConfig = builtins.readFile ../../../../dotfiles/caelestia/cli.json;
    };
  };
}
