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
      imports =
        (with self.modules.homeManager; [
          fish
          htop
          vim
          dotfiles
        ])
        ++ lib.optional (hasRole "workstation") self.modules.homeManager.helix;

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      home.stateVersion = "26.05";
    };
}
