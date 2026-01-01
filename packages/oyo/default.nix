{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "oyo";
  version = "e9e088a681ea67d3564c3e33947777c23e71d58d";

  src = fetchFromGitHub {
    owner = "ahkohd";
    repo = "oyo";
    rev = version;
    hash = "sha256-aP92p+hXJMPsGhYrsppA19fHy7TeNkorOJZou1oGlws=";
  };

  cargoHash = "sha256-cxJFrQkJw8Xk9C9kideR/yQCDW1rPbrrZ6PEQl4nJxI=";

  meta = with lib; {
    description = "A diff viewer that works two ways: step through changes or review a classic scrollable diff";
    homepage = "https://github.com/ahkohd/oyo";
    license = licenses.mit;
    mainProgram = "oy";
  };
}
