{ pkgs, ... }:
{
  # Core features
  nixma.hm.desktop.enable = true;
  nixma.hm.dev.enable = true;
  nixma.hm.earthly.enable = true;
  nixma.hm.git.enable = true;
  nixma.hm.gpgagent.enable = true;
  nixma.hm.jujutsu.enable = true;
  nixma.hm.moderntools.enable = true;

  home.packages = [
    pkgs.mosh
  ];
}
