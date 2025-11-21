{
  config,
  lib,
  libx,
  ...
}:
let
  # Load users as separate modules
  users = libx.mkFeatures {
    featuresDir = ./users;
    inherit config lib;
    optionPrefix = "nixma.darwin.users";
  };
in
{
  # Always import common modules
  imports = [
    ./params.nix
    ./common.nix
  ]
  ++ users;
}
