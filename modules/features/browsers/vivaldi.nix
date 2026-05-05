{ self, ... }:
{
  flake.modules.nixos.vivaldi =
    { config, lib, ... }:
    let
      cfg = config.nixma.nixos.vivaldi;
    in
    {
      options.nixma.nixos.vivaldi.enable =
        lib.mkEnableOption "Vivaldi browser (Wayland) with 1Password integration";

      config = lib.mkIf cfg.enable {
        nixma.nixos._1password.allowedBrowsers = [
          "vivaldi-bin"
        ];

        home-manager.sharedModules = [ self.modules.homeManager.vivaldi ];
      };
    };

  flake.modules.homeManager.vivaldi =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.vivaldi-wayland
      ];
    };
}
