{
  config,
  lib,
  libx,
  ...
}:
let
  moduleName = "maari";
  cfg = config.nixma.darwin.users.${moduleName};
in
{
  options.nixma.darwin.users.${moduleName} =
    # Common user options (shared with NixOS)
    (libx.mkCommonUserOptions lib moduleName) // {
      # Darwin-specific options
      homebrewBrews = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Additional homebrew brews to install for this user";
      };
    };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.username} = {
      name = cfg.username;
      home = "/Users/${cfg.username}";
      openssh.authorizedKeys.keys = cfg.sshKeys;
    };

    nix.settings.trusted-users = [ cfg.username ];

    system.primaryUser = cfg.username;

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

    # Add user-specific homebrew brews
    homebrew.brews = cfg.homebrewBrews;
  };
}
