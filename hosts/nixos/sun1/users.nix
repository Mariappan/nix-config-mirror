{
  lib,
  libx,
  pkgs,
  home-manager,
  inputs,
  outputs,
  ...
}: let
  userId = "maari";
  userName = "Mariappan Ramasamy";
  userEmail = "1221719+nappairam@users.noreply.github.com";
in {
  users.users.${userId} = {
    name = "${userId}";
    description = "${userName}";
    home = "/home/${userId}";
    shell = "${pkgs.fish}/bin/fish";
    extraGroups = ["wheel" "docker" "networkmanager" "vboxusers" "input"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
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
    root = libx.mkNixOsUserConf "root" {
      nixma.core.enable = true;
      nixma.nixos.enable = true;
      nixma.git.enable = true;
    };
    ${userId} = libx.mkNixOsUserConf userId {
      nixma.core.enable = true;
      nixma.nixos.enable = true;
      nixma.git.enable = true;
      nixma.jujutsu.enable = true;
      nixma.xdg.enable = true;
      nixma.quickshell.enable = true;
      nixma.bundles.sun1.enable = true;

      programs.git = {
        userName = "${userName}";
        userEmail = "${userEmail}";
        signing = {
          signByDefault = false;
        };
      };

      programs.jujutsu.settings = {
        user = {
          email = "${userEmail}";
          name = "${userName}";
        };
      };

      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        EARTHLY_SSH_AUTH_SOCK = "/home/${userId}/.ssh/agent/1password.sock";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
