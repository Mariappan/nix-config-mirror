{pkgs, ...}: {
  home.packages = [
    pkgs.wezterm
  ];
  xdg.configFile = {
    "wezterm" = {
      enable = true;
      source = ../dotfiles/wezterm;
      target = "wezterm";
    };
  };
}
