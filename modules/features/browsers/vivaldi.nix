{ self, ... }:
{
  flake.modules.nixos.vivaldi =
    { ... }:
    {
      nixma.nixos._1password.allowedBrowsers = [
        "vivaldi-bin"
      ];

      home-manager.sharedModules = [ self.modules.homeManager.vivaldi ];
    };

  flake.modules.homeManager.vivaldi =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.vivaldi-wayland
      ];
    };
}
