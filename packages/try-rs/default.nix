{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "try-rs";
  version = "0.1.52";

  src = fetchFromGitHub {
    owner = "tassiovirginio";
    repo = "try-rs";
    rev = "v${version}";
    hash = "sha256-ber/Mp9brm9xVlVsZnoaE5r+hzXe/evhp+1ExxE3ZWE=";
  };

  cargoHash = "sha256-PrIGPbHIVQmBp1VHmQGszLw8a+YDY9c0NEU1YChuKvk=";

  meta = with lib; {
    description = "A CLI tool for managing temporary projects with a terminal user interface";
    homepage = "https://github.com/tassiovirginio/try-rs";
    license = licenses.mit;
    mainProgram = "try-rs";
  };
}
