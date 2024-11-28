{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonPackage rec {
  pname = "sagecipher";
  version = "0.7.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tzMPKy9bPQIH+Uwllz0kKCof6coE8537HdCZOcR6utQ=";
  };

  patches = [
    ./remove_pytest_runner.patch
  ];

  propagatedBuildInputs = [
    python3Packages.setuptools
    python3Packages.keyring
    python3Packages.pip
    python3Packages.packaging
    python3Packages.pytest
    python3Packages.paramiko
    python3Packages.pycryptodome
    python3Packages.click
    python3Packages.pyinotify
    python3Packages.keyring
    python3Packages.keyrings-alt
    python3Packages.pynacl
  ];

  meta = with lib; {
    description = "SSH based backend for keyring";
    homepage = "https://github.com/p-sherratt/sagecipher";
    license = licenses.mit;
    mainProgram = "sagecipher";
  };
}
