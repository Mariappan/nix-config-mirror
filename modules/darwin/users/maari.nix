{
  config,
  lib,
  pkgs,
  libx,
  ...
}:
let
  # The module name (from filename)
  moduleName = "maari";
  # The actual system username
  username = "mariappan.ramasamy";
  cfg = config.nixma.darwin.users.${moduleName};
in
{
  options.nixma.darwin.users.${moduleName} =
    # Common user options (shared with NixOS)
    (libx.mkCommonUserOptions lib) // {
      # Darwin-specific options
      homebrewBrews = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Additional homebrew brews to install for this user";
      };
    };

  config = lib.mkIf cfg.enable {
    users.users.${username} = {
      name = username;
      home = "/Users/${username}";
    };

    nix.settings.trusted-users = [ username ];

    # Set as primary user (temporary, will be replaced with params module)
    system.primaryUser = username;

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

    # Add user-specific homebrew brews
    homebrew.brews = cfg.homebrewBrews;
  };
}
