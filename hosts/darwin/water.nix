{
  lib,
  pkgs,
  home-manager,
  outputs,
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
      outputs.homeManagerModules.default
      {
        nixma.hm.core.enable = true;
        nixma.hm.dev.enable = true;
        nixma.hm.git.enable = true;
        nixma.hm.jujutsu.enable = true;
        nixma.hm.wezterm.enable = true;

        programs.git = {
          enable = true;
          userName = "Mariappan Ramasamy";
          userEmail = "maari@qq.com";
        };
        programs.jujutsu.settings = {
          user = {
            email = "Mariappan Ramasamy";
            name = "maari@qq.com";
          };
        };
      }
    ];
  };

  nix.settings.trusted-users = [ "maari" ];

  # Needed for nix darwin temp. Will be replaced soon
  system.primaryUser = "maari";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.enable = false;
  # Enable x64 using rosetta
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
