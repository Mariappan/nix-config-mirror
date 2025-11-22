{ config, ... }:
{
  # Home-manager configuration shared across NixOS and Darwin
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = config._module.specialArgs;
  home-manager.backupFileExtension = "backup";
}
