{ self, ... }:
{
  flake.modules.nixos.vivaldi =
    { ... }:
    {
      nixma.nixos.imported.vivaldi = true;

      imports = [ self.modules.nixos._1password ];

      nixma.nixos._1password.allowedBrowsers = [
        "vivaldi-bin"
      ];

      home-manager.sharedModules = [ self.modules.homeManager.vivaldi ];
    };

  flake.modules.homeManager.vivaldi =
    { pkgs, ... }:
    {
      nixma.imported.vivaldi = true;

      home.packages = [
        pkgs.vivaldi-wayland
      ];
    };
}
