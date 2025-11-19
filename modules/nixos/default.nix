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
  cfg = config.nixma.nixos;

  # Load all .nix files in this directory as features
  # except for default.nix, common.nix, and fishpathfix.nix
  featuresDir = ./.;
  allEntries = builtins.readDir featuresDir;

  # Filter to get only .nix files, excluding special files
  nixFiles = lib.filterAttrs (
    name: type:
      type == "regular"
      && lib.hasSuffix ".nix" name
      && name != "default.nix"       # default.nix is the current file, ignore it
      && name != "common.nix"        # common.nix is included unconditionally
      && name != "fishpathfix.nix"
      && !lib.hasPrefix "_" name
  ) allEntries;

  # Create features with nixma.nixos.{name}.enable pattern
  features = libx.extendModules (name: {
    extraOptions = lib.setAttrByPath
      (lib.splitString "." "nixma.nixos.${name}.enable")
      (lib.mkEnableOption "enable ${name} configuration");
    configExtension = config: (lib.mkIf cfg.${name}.enable config);
  }) (map (name: featuresDir + "/${name}") (builtins.attrNames nixFiles));
in
{
  # Always import common.nix (contains base config and options)
  imports = [ ./common.nix ] ++ features;
}
