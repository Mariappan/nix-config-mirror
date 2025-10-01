{ pkgs, ... }: {
  xdg.configFile = {
    "wlr-which-key" = {
      source = ../../../../../dotfiles/wlr-which-key-config.yaml;
      target = "wlr-which-key/config.yaml";
    };
  };

  home.packages = [
    pkgs.wlr-which-key
  ];
}
