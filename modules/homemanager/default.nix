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

  # Load shared features using the reusable function
  features = libx.mkFeatures {
    featuresDir = ./features;
    inherit config lib;
    optionPrefix = "nixma.hm";
  };

  # Load bundles (available for all platforms)
  bundles = libx.mkBundles {
    bundlesDir = ./bundle;
    inherit config lib;
    optionPrefix = "nixma.hm";
  };
in
{
  imports = [
    ./users/base.nix
  ]
  ++ features
  ++ bundles;
}
