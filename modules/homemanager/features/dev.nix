{pkgs, ...}: {
  home.packages = [
    pkgs.gh
    pkgs.just
    pkgs.uv # Python package manager
    pkgs.ipcalc
    pkgs.tigervnc
  ];
}
