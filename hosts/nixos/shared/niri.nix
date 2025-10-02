{ pkgs, ... }:
{
  imports = [
     ./wayland.nix
     ./wayland-dm.nix
   ];

  programs.niri.enable = true;

  xdg.terminal-exec.settings = {
    niri = [
      "com.mitchellh.ghostty"
    ];
    niri-session = [
      "com.mitchellh.ghostty"
    ];
  };
}
