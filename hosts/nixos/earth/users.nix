{
  lib,
  libx,
  pkgs,
  home-manager,
  inputs,
  outputs,
  ...
}:
let
  userId = "maari";
  userName = "Mariappan Ramasamy";
  userEmail = "1221719+nappairam@users.noreply.github.com";
in
{
  users.users.${userId} = {
    name = "${userId}";
    description = "${userName}";
    home = "/home/${userId}";
    shell = "${pkgs.fish}/bin/fish";
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "vboxusers"
      "input"
    ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P"
    ];
  };
  nix.settings.trusted-users = [ "${userId}" ];
  security.sudo.extraRules = [
    {
      users = [ "${userId}" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  home-manager.users = {
    root = {
      imports = [
        ../../../modules/homemanager/shared/features/core.nix
      ];
    };
    ${userId} = {
      imports = [
        ../../../modules/homemanager/shared/features/core.nix
        ../../../modules/homemanager/shared/features/git
        ../../../modules/homemanager/shared/features/jujutsu.nix
        ../../../modules/homemanager/linux/features/hyprland
        ../../../modules/homemanager/linux/features/caelestia.nix
        ../../../modules/homemanager/linux/features/nixos.nix
        ../../../modules/homemanager/linux/features/xdg.nix
      ];
      # nixma.linux.bundles.air.enable = true;

      programs.git = {
        userName = "${userName}";
        userEmail = "${userEmail}";
      };

      programs.jujutsu.settings = {
        user = {
          email = "${userEmail}";
          name = "${userName}";
        };
      };

      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
