{
  lib,
  home-manager,
  outputs,
  pkgs,
  ...
}:
{
  # Set the primary user for this system
  nixma.darwin.params.primaryUser = "maari";

  # Configure users
  nixma.darwin.users.maari = {
    enable = true;
    bundle = "water";
    name = "Mariappan Ramasamy";
    email = "maari@qq.com";
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable x64 using rosetta
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
