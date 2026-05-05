{
  flake.modules.nixos._1password =
    { config, lib, ... }:
    let
      cfg = config.nixma.nixos._1password;
    in
    {
      options.nixma.nixos._1password.allowedBrowsers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of allowed browsers for 1Password browser integration";
      };

      config = {
        nixma.nixos.imported._1password = true;

        programs._1password.enable = true;
        programs._1password-gui.enable = true;

        environment.etc = {
          "1password/custom_allowed_browsers" = {
            text = lib.concatStringsSep "\n" cfg.allowedBrowsers;
            mode = "0755";
          };
        };
      };
    };
}
