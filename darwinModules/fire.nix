{lib, pkgs, home-manager, ...}: {

  imports = [
    ./shared/common.nix
  ];

  users.users."mariappan.ramasamy" = {
    name = "mariappan.ramasamy";
    home = "/Users/mariappan.ramasamy";
    shell = "${pkgs.fish}/bin/fish";
  };

  home-manager.users."mariappan.ramasamy" = { imports = [
    ../homeModules/shared/core.nix
    ../homeModules/shared/git
    {
      programs.git = {
        userName = "Mariappan Ramasamy";
        userEmail = "142216110+kp-mariappan-ramasamy@users.noreply.github.com";
        signing = {
          key = "09260E7E819CB52451171823FF801DC77426D7C1";
          signByDefault = true;
        };
      };
    }
  ];};

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable x64 using rosetta
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}

