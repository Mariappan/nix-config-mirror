{ self, ... }:
{
  flake.modules.nixos.vivaldi =
    { ... }:
    {
      imports = [ self.modules.nixos._1password ];

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
