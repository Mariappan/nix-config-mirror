{ self, ... }:
{
  programs.hyprlock = {
    enable = true;
    extraConfig = ''
      ${builtins.readFile (self + /dotfiles/hypr/hyprlock.conf)}
    '';
  };
}
