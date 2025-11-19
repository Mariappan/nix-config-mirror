{ pkgs, ... }:
{
  # Enable wayland modules
  nixma.nixos.wayland.enable = true;
  nixma.nixos.wayland-dm.enable = true;

  programs.niri.enable = true;

  xdg.terminal-exec.settings = {
    niri = [
      "com.mitchellh.ghostty"
    ];
    niri-session = [
      "com.mitchellh.ghostty"
    ];
  };

  services.noctalia-shell.enable = true;

  # Add session variables manually.
  # Will be set by uwsm in Hyprland
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
    XDG_CURRENT_DESKTOP = "niri";
  };
}
