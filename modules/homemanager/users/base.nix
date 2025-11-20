{
  config,
  lib,
  ...
}:
let
  cfg = config.nixma.hm.user;
in
{
  options.nixma.hm.user = {
    enable = lib.mkEnableOption "user configuration";

    name = lib.mkOption {
      type = lib.types.str;
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
  };

  config = lib.mkIf cfg.enable {
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
}
