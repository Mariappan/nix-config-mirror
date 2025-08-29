{ pkgs, ... }: {

  programs.caelestia = {
    enable = true;
    extraConfig = builtins.readFile ../../../../dotfiles/caelestia/shell.json;
    cli = {
      enable = true;
      extraConfig = builtins.readFile ../../../../dotfiles/caelestia/cli.json;
    };
  };
}
