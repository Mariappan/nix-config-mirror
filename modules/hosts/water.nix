{ self, inputs, ... }:
{
  flake.darwinConfigurations.water = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.home-manager.darwinModules.home-manager

      self.modules.darwin.common
      self.modules.darwin.user-maari

      (
        { pkgs, ... }:
        {
          nixma.users.maari = {
            name = "Mariappan Ramasamy";
            email = "2441529-Mariappan@users.noreply.gitlab.com";

            # HM features (replaces bundle-water)
            hmModules = with self.modules.homeManager; [
              desktop
              dev
              git
              jujutsu
              moderntools
            ];
          };

          home-manager.sharedModules = [
            {
              home.packages = [
                pkgs.zstd
                pkgs.mosh
                pkgs.tio
              ];
            }
          ];
        }
      )
    ];
  };
}
