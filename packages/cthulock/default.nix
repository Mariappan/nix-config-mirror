{
  lib,
  rustPlatform,
  fetchFromGitHub,
  system,
  pkgs,
}:
let
  nativeBuildInputs = with pkgs; [
    rustPlatform.bindgenHook
    pkg-config
  ];
  buildInputs = with pkgs; [
    libclang
    libxkbcommon
    linux-pam
    libGL
    wayland
    makeWrapper
    fontconfig
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "cthulock";
  version = "cc97b2a514ab7d2bc048064f6061a2c8749cbcb8";

  inherit buildInputs nativeBuildInputs;

  meta = with lib; {
    description = "A Rust binary crate for tree walking operations";
    homepage = "https://gitlab.com/makapuf/treewalker";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.maari ];
    mainProgram = "treewalker";
  };

  src = fetchFromGitHub {
    owner = "FriederHannenheim";
    repo = "cthulock";
    rev = "${version}";
    hash = "sha256-frPuebLh2TMnY6XODJ1/hi7LRxi5KLofU/jKK7vKKpI=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };
  LD_LIBRARY_PATH = "${pkgs.libGL}/lib";
  cargoBuildType = "debug";
  cargoCheckType = "debug";

  dontStrip = true;

  postInstall = ''
    wrapProgram $out/bin/cthulock --prefix LD_LIBRARY_PATH : "${
      pkgs.lib.makeLibraryPath [
        pkgs.wayland
        pkgs.libGL
        pkgs.fontconfig
      ]
    }"
  '';
}
