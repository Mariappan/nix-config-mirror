{
  lib,
  pkgs,
  home-manager,
  ...
}:
let
  userId = "maari";
  userName = "Mariappan Ramasamy";
  userEmail = "2441529+mariappan@users.noreply.gitlab.com";
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHmCMRUlvFEr8DTgChajPHJA069XKU+RECk/hurkIo2h"
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
      nixma.linux.bundles.root.enable = true;
    };
    ${userId} = {
      nixma.linux.bundles.blackmamba.enable = true;

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
        EARTHLY_SSH_AUTH_SOCK = "/home/${userId}/.ssh/agent/1password.sock";
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
