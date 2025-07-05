{
  lib,
  pkgs,
  home-manager,
  ...
}:
{
  imports = [
    ./shared/common.nix
  ];

  users.users.maari = {
    name = "maari";
    home = "/Users/maari";
    shell = "${pkgs.fish}/bin/fish";
  };

  home-manager.users.maari = {
    imports = [
      ../../modules/homemanager/features/core.nix
      ../../modules/homemanager/features/dev.nix
      ../../modules/homemanager/features/git
      {
        programs.git = {
          enable = true;
          userName = "Mariappan Ramasamy";
          userEmail = "maari@qq.com";
        };
      }
    ];
  };

  nix.settings.trusted-users = [ "maari" ];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable x64 using rosetta
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
