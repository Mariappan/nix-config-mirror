{pkgs, ...}: {
  home.packages = [
    pkgs.gh
    pkgs.uv  # Python package manager
    pkgs.ipcalc
    pkgs.tigervnc
  ];
}
