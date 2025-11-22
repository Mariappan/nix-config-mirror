{ pkgs, ... }:
{
  # Tools which are replacement for older versions
  home.packages = [
    pkgs.bat
    pkgs.difftastic
    pkgs.duf
    pkgs.fd
    pkgs.fzf
    pkgs.hyperfine
    pkgs.lsd
    pkgs.ncdu
    pkgs.pik
    pkgs.ripgrep
    pkgs.sd
    pkgs.sshuttle
    pkgs.tldr
    pkgs.tree
    pkgs.xan
    pkgs.yazi
    pkgs.yasm
  ];

}
