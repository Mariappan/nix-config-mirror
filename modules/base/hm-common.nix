{ self, ... }:
{
  flake.modules.homeManager.hm-common =
    { lib, ... }:
    {
      imports = [
        self.modules.homeManager.fish
        self.modules.homeManager.htop
        self.modules.homeManager.vim
        self.modules.homeManager.dotfiles
      ];

      options.nixma.imported = lib.mkOption {
        type = lib.types.attrsOf lib.types.bool;
        default = { };
        internal = true;
        description = ''
          Sentinel set by each homeManager module when imported, for
          introspection (e.g. `just enabled-hm <host>`).
        '';
      };

      config = {
        nixma.imported.hm-common = true;

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;

        home.stateVersion = "26.05";
      };
    };
}
