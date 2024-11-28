{pkgs ? import <nixpkgs> {}, ...}: rec {
  nixma = {
    # Packages with an actual source
    ddlm = pkgs.callPackage ./ddlm {};
  };
}
