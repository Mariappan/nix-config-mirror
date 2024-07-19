{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hyprland_anyrun.nix
  ];

  xdg.configFile = {
    "hypr" = {
      enable = true;
      source = ../dotfiles/hypr;
      target = "hypr";
    };
    "waybar" = {
      enable = true;
      source = ../dotfiles/waybar;
      target = "waybar";
    };
    "swaync" = {
      enable = true;
      source = ../dotfiles/swaync;
      target = "swaync";
    };
  };
}
