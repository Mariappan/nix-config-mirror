{ self, ... }:
{
  flake.modules.homeManager.hyprlock =
    { ... }:
    {
      nixma.imported.hyprlock = true;

      programs.hyprlock = {
        enable = true;
        extraConfig = ''
          ${builtins.readFile (self + /dotfiles/hypr/hyprlock.conf)}
        '';
      };
    };
}
