{ self, ... }:
{
  flake.modules.homeManager.hyprlock =
    { ... }:
    {
      programs.hyprlock = {
        enable = true;
        extraConfig = ''
          ${builtins.readFile (self + /dotfiles/hypr/hyprlock.conf)}
        '';
      };
    };
}
