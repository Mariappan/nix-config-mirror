{
  pkgs,
  lib,
  ...
}:
{
  nixma.hm.core.enable = true;
  nixma.hm.git.enable = true;
  nixma.hm.jujutsu.enable = true;

  # Linux-specific configuration
  nixma.hm.linux.xdg.enable = lib.mkIf pkgs.stdenv.isLinux true;
}
