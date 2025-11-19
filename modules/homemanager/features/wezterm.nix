{
  pkgs,
  lib,
  self,
  ...
}:
{
  home.packages = [
    pkgs.wezterm
  ];

  xdg.configFile = {
    "wezterm" = {
      enable = true;
      source = self + /dotfiles/wezterm/wezterm.lua;
      target = "wezterm/wezterm.lua";
    };
    "wezterm-utils" = {
      enable = true;
      source = self + /dotfiles/wezterm/utils.lua;
      target = "wezterm/utils.lua";
    };
    "wezterm-settings" = {
      enable = true;
      source = self + /dotfiles/wezterm/settings.lua;
      target = "wezterm/settings.lua";
    };
    "wezterm-settings-dir" = {
      enable = true;
      source = self + /dotfiles/wezterm/settings;
      target = "wezterm/settings";
    };
  };

  # home.activation = {
  #   weztermAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #     run install -m 444 -C ${builtins.toPath ${self}/dotfiles/wezterm/machine_local.lua} -D $HOME/.config/wezterm/machine_local/init.lua
  #   '';
  # };
}
