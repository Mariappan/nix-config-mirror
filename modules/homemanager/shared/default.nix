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

  # Load bundles using the reusable function
  bundles = libx.mkBundles {
    bundlesDir = ./bundles;
    inherit config lib;
    optionPrefix = "nixma";
  };
in
{
  imports = [ ] ++ features ++ bundles;
}
