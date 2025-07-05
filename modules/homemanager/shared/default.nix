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

  # Taking all modules in ./features and adding enables to them
  features = libx.extendModules (name: {
    extraOptions = {
      nixma.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
    };

    configExtension = config: (lib.mkIf cfg.${name}.enable config);
  }) (libx.filesIn ./features);

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
