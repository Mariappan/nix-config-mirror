{pkgs, lib, ...}: {
  home.packages = [
    pkgs.gh
    pkgs.just
    pkgs.uv # Python package manager
    pkgs.ipcalc
    # pkgs.netcat-openbsd
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.tigervnc
  ];
}
