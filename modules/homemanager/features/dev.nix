{
  pkgs,
  lib,
  ...
}:
{
  home.packages = [
    pkgs.atuin
    pkgs.devenv
    pkgs.expect
    pkgs.gh
    pkgs.gnupg
    pkgs.ipcalc
    pkgs.iperf3
    pkgs.just
    pkgs.lsof
    pkgs.universal-ctags
    pkgs.uv # Python package manager
    pkgs.jwt-cli
    # pkgs.netcat-openbsd
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    # pkgs.tigervnc
  ];
}
