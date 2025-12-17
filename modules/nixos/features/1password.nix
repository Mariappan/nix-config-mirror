{ config, lib, ... }:
let
  cfg = config.nixma.nixos."1password";
in
{
  options.nixma.nixos."1password".allowedBrowsers = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "List of allowed browsers for 1Password browser integration";
  };

  config = {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ config.nixma.nixos.params.primaryUser ];
    };

    environment.etc = {
      "1password/custom_allowed_browsers" = {
        text = lib.concatStringsSep "\n" cfg.allowedBrowsers;
        mode = "0755";
      };
    };
  };
}
