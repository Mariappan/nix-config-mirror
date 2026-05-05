{ self, inputs, ... }:
{
  flake.darwinConfigurations.fire = inputs.nix-darwin.lib.darwinSystem {
    modules = [

      self.modules.darwin.common
      self.modules.darwin.user-maari

      (
        { pkgs, ... }:
        {
          nixma.darwin.formFactor = "laptop";
          nixma.darwin.roles = [ "workstation" ];

          nixma.users.maari = {
            username = "mariappan.ramasamy";
            name = "Mariappan Ramasamy";
            email = "142216110+kp-mariappan-ramasamy@users.noreply.github.com";
            gitSigningKey = "3B7DA4A8AF8C211443B571A2AD921C91A406F32D";
            gitSignByDefault = true;

            # HM features (replaces bundle-fire)
            hmModules = with self.modules.homeManager; [
              dev
              earthly
              git
              gpgagent
              jujutsu
              moderntools
            ];
          };

          homebrew.brews = [
            "gnupg"
            "rbenv"
          ];

          home-manager.sharedModules = [
            {
              home.packages = [
                pkgs.mosh
              ];
            }
          ];
        }
      )
    ];
  };
}
