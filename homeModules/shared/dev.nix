{pkgs, ...}: {
  home.packages = [
    pkgs.gh
    pkgs.ipcalc
    pkgs.tigervnc
  ];
}
