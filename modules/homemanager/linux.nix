{
  config,
  lib,
  libx,
  ...
}:
let
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
