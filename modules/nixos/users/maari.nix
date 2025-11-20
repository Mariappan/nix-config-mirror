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
  options.nixma.nixos.users.${username} =
    # Common user options (shared with Darwin)
    (libx.mkCommonUserOptions lib) // {
      # NixOS-specific options
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
