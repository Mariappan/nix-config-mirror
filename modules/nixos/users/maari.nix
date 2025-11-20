{
  config,
  lib,
  pkgs,
  libx,
  ...
}:
let
  moduleName = "maari";
  cfg = config.nixma.nixos.users.${moduleName};
in
{
  options.nixma.nixos.users.${moduleName} =
    # Common user options (shared with Darwin)
    (libx.mkCommonUserOptions lib moduleName) // {
      # NixOS-specific options
      extraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Additional groups for the user (added to default groups)";
      };
    };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.username} = {
      name = cfg.username;
      home = "/home/${cfg.username}";
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

    nix.settings.trusted-users = [ cfg.username ];

    security.sudo.extraRules = [
      {
        users = [ cfg.username ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    home-manager.users.${cfg.username} = libx.mkHmUserConf {
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
