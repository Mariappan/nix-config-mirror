{
  lib,
  pkgs,
  home-manager,
  ...
}: {
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
      ../../modules/homemanager/core.nix
      ../../modules/homemanager/dev.nix
      ../../modules/homemanager/git
      {
        programs.git = {
          userName = "Mariappan Ramasamy";
          userEmail = "142216110+kp-mariappan-ramasamy@users.noreply.github.com";
          signing = {
            key = "3B7DA4A8AF8C211443B571A2AD921C91A406F32D";
            signByDefault = true;
          };
        };
      }
    ];
  };

  homebrew.brews = ["clang-format" "swift-format" "jq" "gnupg" "rbenv"];

  nix.settings.trusted-users = ["mariappan.ramasamy"];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable x64 using rosetta
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
