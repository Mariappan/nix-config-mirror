{
  pkgs ? import <nixpkgs> { },
  ...
}:
rec {
  # Packages with an actual source
  ddlm = pkgs.callPackage ./ddlm { };
  sagecipher = pkgs.callPackage ./sagecipher { };
  caelestia = pkgs.callPackage ./caelestia { };
}
