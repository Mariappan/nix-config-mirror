{ pkgs, ... }:
{
  nixma.hm.desktop.enable = true;
  nixma.hm.dev.enable = true;
  nixma.hm.git.enable = true;
  nixma.hm.jujutsu.enable = true;
  nixma.hm.moderntools.enable = true;

  home.packages = [
    pkgs.zstd
    pkgs.mosh
    pkgs.tio
  ];
}
