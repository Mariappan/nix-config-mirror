{ self, inputs, ... }:
{
  flake.modules.nixos.user-root =
    { ... }:
    {
      nixma.nixos.imported.user-root = true;

      home-manager.users.root = {
        imports = [
          self.modules.homeManager.hm-common
          inputs.nix-index-database.homeModules.nix-index
          # Root bundle inlined (was: desktop, git, jujutsu)
          self.modules.homeManager.desktop
          self.modules.homeManager.git
          self.modules.homeManager.jujutsu
        ];
      };
    };
}
