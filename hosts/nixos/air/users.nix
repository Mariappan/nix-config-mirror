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
  userEmail = "142216110+kp-mariappan-ramasamy@users.noreply.github.com";
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

  home-manager.verbose = true;
  home-manager.users = {
    root = libx.mkNixOsUserConf "root" {
      nixma.linux.bundles.root.enable = true;
    };
    ${userId} = libx.mkNixOsUserConf userId {
      nixma.linux.bundles.air.enable = true;

      programs.git = {
        settings.user = {
          name = "${userName}";
          email = "${userEmail}";
        };
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
          sign-on-push = true;
        };
      };
    };
  };
}
