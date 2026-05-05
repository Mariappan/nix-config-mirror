{ self, ... }:
{
  flake.modules.nixos.user-root =
    { ... }:
    {
      nixma.nixos.imported.user-root = true;

      home-manager.users.root = {
        imports = [
          self.modules.homeManager.hm-common
          self.modules.homeManager.git
        ];
      };
    };
}
