{
  lib,
  pkgs,
  home-manager,
  ...
}: let
  userId = "maari";
  userName = "Mariappan Ramasamy";
  userEmail = "142216110+kp-mariappan-ramasamy@users.noreply.github.com";
in {
  imports = [
    ./shared/common.nix
  ];

  users.users."mariappan.ramasamy" = {
    name = "mariappan.ramasamy";
    home = "/Users/mariappan.ramasamy";
    shell = "${pkgs.fish}/bin/fish";
  };

  home-manager.users."mariappan.ramasamy" = {
    imports = [
      ../../modules/homemanager/features/core.nix
      ../../modules/homemanager/features/dev.nix
      ../../modules/homemanager/features/git
      ../../modules/homemanager/features/jujutsu.nix
      {
        programs.git = {
          userName = "${userName}";
          userEmail = "${userEmail}";
          signing = {
            key = "3B7DA4A8AF8C211443B571A2AD921C91A406F32D";
            signByDefault = true;
          };
        };
        programs.jujutsu.settings = {
          user = {
            email = "${userEmail}";
            name = "${userName}";
          };
          signing = {
            key = "3B7DA4A8AF8C211443B571A2AD921C91A406F32D";
          };
          git = {
            signOnPush = true;
          };
        };

      }
    ];
  };

  homebrew.brews = ["clang-format" "swift-format" "jq" "gnupg" "rbenv"];

  nix.settings.trusted-users = ["mariappan.ramasamy"];

  # Needed for nix darwin temp. Will be replaced soon
  system.primaryUser = "mariappan.ramasamy";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable x64 using rosetta
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
