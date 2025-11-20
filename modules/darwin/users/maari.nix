{
  config,
  lib,
  pkgs,
  libx,
  ...
}:
let
  # The actual system username
  systemUsername = "mariappan.ramasamy";
  # The module name (from filename)
  moduleName = "maari";
  cfg = config.nixma.darwin.users.${moduleName};
in
{
  options.nixma.darwin.users.${moduleName} = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "Mariappan Ramasamy";
      description = "Full name of the user";
    };

    email = lib.mkOption {
      type = lib.types.str;
      description = "Email address for git/jujutsu";
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

    homebrewBrews = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional homebrew brews to install for this user";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${systemUsername} = {
      name = systemUsername;
      home = "/Users/${systemUsername}";
    };

    nix.settings.trusted-users = [ systemUsername ];

    # Set as primary user (temporary, will be replaced with params module)
    system.primaryUser = systemUsername;

    home-manager.users.${systemUsername} = libx.mkHmUserConf {
      nixma.hm.core.enable = true;
      nixma.hm.dev.enable = true;
      nixma.hm.git.enable = true;
      nixma.hm.jujutsu.enable = true;
      nixma.hm.moderntools.enable = true;
      nixma.hm.gpgagent.enable = true;

      nixma.hm.user = {
        enable = true;
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
