{
  pkgs ? import <nixpkgs> { },
  ...
}:
rec {
  # Packages with an actual source
  ddlm = pkgs.callPackage ./ddlm { };
  sagecipher = pkgs.callPackage ./sagecipher { };
  script12bt-font = pkgs.callPackage ./script12bt-font { };
  meslolgsnf-font = pkgs.callPackage ./meslolgsnf-font { };
}
