{
  lib,
  home-manager,
  outputs,
  pkgs,
  ...
}:
{
  # Set the primary user for this system
  nixma.darwin.params.primaryUser = "mariappan.ramasamy";

  # Configure users
  nixma.darwin.users.maari = {
    enable = true;
    name = "Mariappan Ramasamy";
    email = "142216110+kp-mariappan-ramasamy@users.noreply.github.com";
    gitSigningKey = "3B7DA4A8AF8C211443B571A2AD921C91A406F32D";
    gitSignByDefault = true;
    homebrewBrews = [
      "gnupg"
      "rbenv"
    ];
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable x64 using rosetta
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
