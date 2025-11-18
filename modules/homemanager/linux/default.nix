{
  pkgs,
  system,
  inputs,
  config,
  lib,
  libx,
  ...
}:
let
  cfg = config.nixma.linux;

  # Taking all modules in ./features and adding enables to them
  # Filter to only include .nix files, excluding directories
  features = libx.extendModules (name: {
    extraOptions = {
      nixma.linux.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
    };

    configExtension = config: (lib.mkIf cfg.${name}.enable config);
  }) (builtins.filter (f: lib.hasSuffix ".nix" (builtins.toString f)) (libx.filesIn ./features));

  # Taking all module bundles in ./bundles and adding bundle.enables to them
  bundles = libx.extendModules (name: {
    extraOptions = {
      nixma.linux.bundles.${name}.enable = lib.mkEnableOption "enable ${name} module bundle";
    };

    configExtension = config: (lib.mkIf cfg.bundles.${name}.enable config);
  }) (libx.filesIn ./bundles);
in
{
  imports = [ ] ++ features ++ bundles;
}
