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

  # Load features using the reusable function
  features = libx.mkFeatures {
    featuresDir = ./features;
    inherit config lib;
    optionPrefix = "nixma.linux";
  };

  # Load bundles using the reusable function
  bundles = libx.mkBundles {
    bundlesDir = ./bundles;
    inherit config lib;
    optionPrefix = "nixma.linux";
  };
in
{
  imports = [ ] ++ features ++ bundles;
}
