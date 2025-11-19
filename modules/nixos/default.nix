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

  # Load features using the reusable function
  features = libx.mkFeatures {
    featuresDir = ./features;
    inherit config lib;
    optionPrefix = "nixma.nixos";
  };
in
{
  # Always import common.nix (contains base config and options)
  imports = [ ./common.nix ] ++ features;
}
