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

  # Load bundles (Linux-specific, includes linux feature enables)
  bundles = libx.mkBundles {
    bundlesDir = ./bundle;
    inherit config lib;
    optionPrefix = "nixma.hm";
  };
in
{
  imports = [ ] ++ linuxFeatures ++ bundles;
}
