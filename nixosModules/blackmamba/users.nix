{
  lib,
  pkgs,
  home-manager,
  ...
}: let
  userId = "maari";
  userName = "Mariappan Ramasamy";
  userEmail = "2441529+mariappan@users.noreply.gitlab.com";
in {
  users.users.${userId} = {
    name = "${userId}";
    description = "${userName}";
    home = "/home/${userId}";
    shell = "${pkgs.fish}/bin/fish";
    extraGroups = ["wheel" "docker" "networkmanager" "vboxusers"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHmCMRUlvFEr8DTgChajPHJA069XKU+RECk/hurkIo2h"
    ];
  };
  nix.settings.trusted-users = ["${userId}"];
  security.sudo.extraRules = [
    {
      users = ["${userId}"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  home-manager.users = {
    root = {
      imports = [
        ../../homeModules/shared/core.nix
        ../../homeModules/shared/nixos.nix
        ../../homeModules/shared/git
      ];
    };
    ${userId} = {
      imports = [
        ../../homeModules/shared/core.nix
        ../../homeModules/shared/nixos.nix
        ../../homeModules/shared/git
        ../../homeModules/shared/xdg.nix
        ../../homeModules/shared/rust.nix
        ../../homeModules/shared/dev.nix
        ../../homeModules/shared/debug.nix
      ];
      programs.git = {
        userName = "${userName}";
        userEmail = "${userEmail}";
      };
      home.sessionVariables = {
        EARTHLY_SSH_AUTH_SOCK = "/home/${userId}/.ssh/agent/1password.sock";
      };
    };
  };
}
