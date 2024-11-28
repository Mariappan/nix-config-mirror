{
  lib,
  pkgs,
  fetchFromGitHub,
}: let
  pname = "ddlm";
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname;
    version = "0.1.0";

    src = fetchFromGitHub {
      owner = "deathowl";
      repo = pname;
      rev = "8a7213909c7a7f4672a6db05ca5fdd0b37c5ceeb";
      sha256 = "sha256-V3084fBpuCkJ9N0Rw6uBvjQPtZi2BXGxlvmEYH7RahE=";
    };

    cargoHash = "sha256-DGq+s5nStfQ0BYl3VBsf1uDbLpa+w0zjTMc+TCIiVF0=";
    meta = with lib; {
      homepage = "https://github.com/deathowl/ddlm";
    };
  }
