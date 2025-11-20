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
  cfg = config.nixma.hm;

  # Load linux-specific features
  linuxFeatures = libx.mkFeatures {
    featuresDir = ./linux;
    inherit config lib;
    optionPrefix = "nixma.hm.linux";
  };
in
{
  imports = [ ] ++ linuxFeatures;
}
