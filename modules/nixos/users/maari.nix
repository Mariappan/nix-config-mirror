{
  config,
  lib,
  pkgs,
  libx,
  ...
}:
let
  username = "maari";
  cfg = config.nixma.nixos.users.${username};
in
{
  options.nixma.nixos.users.${username} = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "Mariappan Ramasamy";
      description = "Full name of the user";
    };

    email = lib.mkOption {
      type = lib.types.str;
      description = "Email address for git/jujutsu";
    };

    sshKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "SSH authorized keys";
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional groups for the user (added to default groups)";
    };

    bundle = lib.mkOption {
      type = lib.types.str;
      description = "Home-manager bundle to enable (e.g., 'air', 'sun1')";
    };

    gitSigningKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "GPG key for git signing";
    };

    gitSignByDefault = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to sign commits by default";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${username} = {
      name = username;
      description = cfg.name;
      home = "/home/${username}";
      shell = "${pkgs.fish}/bin/fish";
      extraGroups = [
        "wheel"
        "docker"
        "networkmanager"
        "vboxusers"
        "input"
      ]
      ++ cfg.extraGroups;
      isNormalUser = true;
      openssh.authorizedKeys.keys = cfg.sshKeys;
    };

    nix.settings.trusted-users = [ username ];

    security.sudo.extraRules = [
      {
        users = [ username ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    home-manager.users.${username} = libx.mkHmUserConf {
      nixma.hm.user = {
        enable = true;
        bundle = cfg.bundle;
        name = cfg.name;
        email = cfg.email;
        gitSigningKey = cfg.gitSigningKey;
        gitSignByDefault = cfg.gitSignByDefault;
      };
    };
  };
}
