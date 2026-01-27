{
  pkgs ? import <nixpkgs> { },
  ...
}:
rec {
  # Packages with an actual source
  cthulock = pkgs.callPackage ./cthulock { };
  ddlm = pkgs.callPackage ./ddlm { };
  oyo = pkgs.callPackage ./oyo { };
  treewalker = pkgs.callPackage ./treewalker { };
  try-rs = pkgs.callPackage ./try-rs { };
  sagecipher = pkgs.callPackage ./sagecipher { };
  script12bt-font = pkgs.callPackage ./script12bt-font { };
  meslolgsnf-font = pkgs.callPackage ./meslolgsnf-font { };
  wired_wifi_toggle = pkgs.callPackage ./wired_wifi_toggle { };
}
