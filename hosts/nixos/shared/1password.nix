{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "maari" ];
    # polkitPolicyOwners = ["${userId}"];  # TODO: Remove this hardcoding
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        .zen-wrapped
        vivaldi-bin
      '';
      mode = "0755";
    };
  };
}
