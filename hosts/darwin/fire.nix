{ ... }:
{
  # Set the primary user for this system
  nixma.darwin.params.primaryUser = "mariappan.ramasamy";

  # Configure users
  nixma.darwin.users.maari = {
    enable = true;
    username = "mariappan.ramasamy";
    bundle = "fire";
    name = "Mariappan Ramasamy";
    email = "142216110+kp-mariappan-ramasamy@users.noreply.github.com";
    gitSigningKey = "3B7DA4A8AF8C211443B571A2AD921C91A406F32D";
    gitSignByDefault = true;
  };

  # Host-specific homebrew packages
  homebrew.brews = [
    "gnupg"
    "rbenv"
  ];
}
