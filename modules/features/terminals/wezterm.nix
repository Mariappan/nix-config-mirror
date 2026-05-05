{
  flake.modules.homeManager.wezterm =
    { pkgs, ... }:
    {
      nixma.imported.wezterm = true;

      home.packages = [
        pkgs.wezterm
      ];
    };
}
