{
  lib,
  pkgs,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "caelestia";
  version = "2025.07.01";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "caelestia-dots";
    repo = "cli";
    # When updating the sha, update the version number above too
    rev = "27054dfae9b64bb1b0fe498851b0dc4367f7e879";
    sha256 = "sha256-3IMcnF35otla0JVybaKC4PEKJTGl7lDvCM9sLCqoFUI=";
  };

  propagatedBuildInputs = [
    python3Packages.hatchling
    python3Packages.hatch-vcs
    python3Packages.pillow
    python3Packages.materialyoucolor
  ];

  meta = with lib; {
    description = "Caelestia cli utils";
    homepage = "https://github.com/caelestia-dots/cli";
    license = licenses.mit;
    mainProgram = "caelestia";
  };
}
