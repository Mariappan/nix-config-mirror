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

  # Load users as separate features
  users = libx.mkFeatures {
    featuresDir = ./users;
    inherit config lib;
    optionPrefix = "nixma.nixos.users";
  };
in
{
  # Always import common.nix (contains base config and options)
  imports = [ ./common.nix ] ++ features ++ users;
}
