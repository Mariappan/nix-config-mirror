{
  flake.modules.homeManager.wezterm =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.wezterm
      ];
    };
}
