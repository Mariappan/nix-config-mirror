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
  userEmail = "142216110+kp-mariappan-ramasamy@users.noreply.github.com";
in {
  users.users.${userId} = {
    name = "${userId}";
    description = "${userName}";
    home = "/home/${userId}";
    shell = "${pkgs.fish}/bin/fish";
    extraGroups = ["wheel" "docker" "networkmanager" "vboxusers" "input"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P"
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
      nixma.xdg.enable = true;
      nixma.air.enable = true;
      nixma.jujutsu.enable = true;

      programs.git = {
        userName = "${userName}";
        userEmail = "${userEmail}";
        signing = {
          key = "3B7DA4A8AF8C211443B571A2AD921C91A406F32D";
          signByDefault = true;
        };
      };

      programs.jujutsu.settings = {
        user = {
          email = "${userEmail}";
          name = "${userName}";
        };
        signing = {
          key = "3B7DA4A8AF8C211443B571A2AD921C91A406F32D";
        };
        git = {
          signOnPush = true;
        };
      };

      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        # SSH_AUTH_SOCK = "/home/${userId}/.ssh/agent/1password.sock";
        EARTHLY_SSH_AUTH_SOCK = "/home/${userId}/.ssh/agent/1password.sock";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
