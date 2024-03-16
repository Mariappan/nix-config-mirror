{lib, pkgs, home-manager, ...}: {

  imports = [
    ./shared/common.nix
  ];

  users.users.maari = {
    name = "maari";
    home = "/Users/maari";
    shell = "${pkgs.fish}/bin/fish";
  };

  home-manager.users.maari = { imports = [
    ../homeModules/shared/core.nix
  ];};

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable x64 using rosetta
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}

