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
  cfg = config.nixma;

  # Load features using the reusable function
  features = libx.mkFeatures {
    featuresDir = ./features;
    inherit config lib;
    optionPrefix = "nixma";
  };

  # Taking all module bundles in ./bundles and adding bundle.enables to them
  bundles = libx.extendModules (name: {
    extraOptions = {
      nixma.bundles.${name}.enable = lib.mkEnableOption "enable ${name} module bundle";
    };

    configExtension = config: (lib.mkIf cfg.bundles.${name}.enable config);
  }) (libx.filesIn ./bundles);
in
{
  imports = [ ] ++ features ++ bundles;
}
