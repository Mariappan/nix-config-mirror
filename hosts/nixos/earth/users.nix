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
        ../../../modules/homemanager/core.nix
        ../../../modules/homemanager/nixos.nix
        ../../../modules/homemanager/git
      ];
    };
    ${userId} = {
      imports = [
        ../../../modules/homemanager/core.nix
        ../../../modules/homemanager/nixos.nix
        ../../../modules/homemanager/git
        ../../../modules/homemanager/xdg.nix
        ../../../modules/homemanager/rust.nix
        ../../../modules/homemanager/dev.nix
        ../../../modules/homemanager/debug.nix
      ];

      programs.git = {
        userName = "${userName}";
        userEmail = "${userEmail}";
        signing = {
          key = "09260E7E819CB52451171823FF801DC77426D7C1";
          signByDefault = true;
        };
      };

      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        EARTHLY_SSH_AUTH_SOCK = "/home/${userId}/.ssh/agent/1password.sock";
      };
    };
  };
}
