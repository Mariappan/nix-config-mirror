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
  ];};

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable x64 using rosetta
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}

