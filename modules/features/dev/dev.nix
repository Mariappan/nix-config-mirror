{
  flake.modules.homeManager.dev =
    { pkgs, lib, ... }:
    {
      nixma.imported.dev = true;

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
        pkgs.openssl
        pkgs.opentofu
        pkgs.nixma.try-rs
        # pkgs.netcat-openbsd
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        # pkgs.tigervnc
        pkgs.nftables
      ];
    };
}
