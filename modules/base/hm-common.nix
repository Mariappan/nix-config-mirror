{ self, ... }:
{
  flake.modules.homeManager.hm-common =
    { osConfig, lib, ... }:
    let
      # Roles come from the NixOS profile module.
      # On darwin hosts default to workstation
      roles = osConfig.nixma.nixos.roles or [ "workstation" ];
      hasRole = role: lib.elem role roles;
    in
    {
      imports = [
        self.modules.homeManager.fish
        self.modules.homeManager.htop
        self.modules.homeManager.vim
        self.modules.homeManager.dotfiles
        self.modules.homeManager.desktop
      ]
      ++ lib.optional (hasRole "workstation") self.modules.homeManager.helix;

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
