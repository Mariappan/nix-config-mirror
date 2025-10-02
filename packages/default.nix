{
  pkgs ? import <nixpkgs> { },
  ...
}:
rec {
  # Packages with an actual source
  ddlm = pkgs.callPackage ./ddlm { };
  treewalker = pkgs.callPackage ./treewalker { };
  sagecipher = pkgs.callPackage ./sagecipher { };
  script12bt-font = pkgs.callPackage ./script12bt-font { };
  meslolgsnf-font = pkgs.callPackage ./meslolgsnf-font { };
  wired_wifi_toggle = pkgs.callPackage ./wired_wifi_toggle { };
  cosmic-ext-alt = pkgs.callPackage ./cosmic-ext-alt { };
}
