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
      nixma.linux.bundles.root.enable = true;
    };
    ${userId} = {
      nixma.linux.bundles.earth.enable = true;

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
