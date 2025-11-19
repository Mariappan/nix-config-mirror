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

  # Get all entries in features directory
  allEntries = builtins.readDir ./features;

  # Top-level .nix files become nixma.linux.{name}.enable
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) allEntries;
  topLevelFeatures = libx.extendModules (name: {
    extraOptions = {
      nixma.linux.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
    };
    configExtension = config: (lib.mkIf cfg.${name}.enable config);
  }) (map (name: ./features + "/${name}") (builtins.attrNames nixFiles));

  # Directories become nested features: nixma.linux.{dirname}.{filename}.enable
  # Special case: default.nix creates nixma.linux.{dirname}.enable
  directories = lib.filterAttrs (name: type: type == "directory") allEntries;
  nestedFeatures = lib.flatten (map (dirName:
    let
      dirPath = ./features + "/${dirName}";
      filesInDir = builtins.readDir dirPath;
      nixFilesInDir = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) filesInDir;

      # Separate default.nix from other files
      defaultNix = if nixFilesInDir ? "default.nix" then [ (dirPath + "/default.nix") ] else [];
      otherNixFiles = lib.filterAttrs (name: type: name != "default.nix") nixFilesInDir;

      # default.nix creates nixma.linux.{dirname}.enable
      defaultFeature = if (builtins.length defaultNix > 0) then
        libx.extendModules (name: {
          extraOptions = {
            nixma.linux.${dirName}.enable = lib.mkEnableOption "enable ${dirName} configuration";
          };
          configExtension = config: (lib.mkIf cfg.${dirName}.enable config);
        }) defaultNix
      else [];

      # Other files create nixma.linux.{dirname}.{filename}.enable
      otherFeatures = libx.extendModules (fileName: {
        extraOptions = {
          nixma.linux.${dirName}.${fileName}.enable = lib.mkEnableOption "enable ${dirName} ${fileName} configuration";
        };
        configExtension = config: (lib.mkIf cfg.${dirName}.${fileName}.enable config);
      }) (map (name: dirPath + "/${name}") (builtins.attrNames otherNixFiles));
    in
    defaultFeature ++ otherFeatures
  ) (builtins.attrNames directories));

  features = topLevelFeatures ++ nestedFeatures;

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
