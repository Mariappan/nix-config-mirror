{pkgs, ...}: {
  home.packages = [
    pkgs.gh
    pkgs.ipcalc
    pkgs.tigervnc
    pkgs.python312Packages.keyring
  ];
}
