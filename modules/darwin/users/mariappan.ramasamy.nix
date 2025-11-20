{
  config,
  lib,
  pkgs,
  libx,
  ...
}:
let
  username = "mariappan.ramasamy";
  cfg = config.nixma.darwin.users.${username};
in
{
  options.nixma.darwin.users.${username} = {
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
    users.users.${username} = {
      name = username;
      home = "/Users/${username}";
    };

    nix.settings.trusted-users = [ username ];

    # Set as primary user (temporary, will be replaced with params module)
    system.primaryUser = username;

    home-manager.users.${username} = {
      imports = [
        config._module.specialArgs.outputs.homeManagerModules.default
      ];

      nixma.hm.core.enable = true;
      nixma.hm.dev.enable = true;
      nixma.hm.git.enable = true;
      nixma.hm.jujutsu.enable = true;
      nixma.hm.moderntools.enable = true;
      nixma.hm.gpgagent.enable = true;

      programs.git = {
        settings.user = {
          name = cfg.name;
          email = cfg.email;
        };
        signing = lib.mkIf (cfg.gitSigningKey != null) {
          key = cfg.gitSigningKey;
          signByDefault = cfg.gitSignByDefault;
        };
      };

      programs.jujutsu.settings = {
        user = {
          email = cfg.email;
          name = cfg.name;
        };
        signing = lib.mkIf (cfg.gitSigningKey != null) {
          key = cfg.gitSigningKey;
        };
        git = lib.mkIf cfg.gitSignByDefault {
          sign-on-push = true;
        };
      };
    };

    # Add user-specific homebrew brews
    homebrew.brews = cfg.homebrewBrews;
  };
}
