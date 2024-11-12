{
  lib,
  pkgs,
  home-manager,
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
        ../../homeModules/shared/air.nix
      ];

      programs.git = {
        userName = "${userName}";
        userEmail = "${userEmail}";
        signing = {
          key = "3B7DA4A8AF8C211443B571A2AD921C91A406F32D";
          signByDefault = true;
        };
      };

      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        SSH_AUTH_SOCK = "/home/${userId}/.ssh/agent/1password.sock";
        EARTHLY_SSH_AUTH_SOCK = "/home/${userId}/.ssh/agent/1password.sock";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
