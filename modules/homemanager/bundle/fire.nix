{
  pkgs,
  lib,
  ...
}:
{
  # Core features
  nixma.hm.core.enable = true;
  nixma.hm.moderntools.enable = true;
  nixma.hm.git.enable = true;
  nixma.hm.jujutsu.enable = true;
  nixma.hm.dev.enable = true;
  nixma.hm.gpgagent.enable = true;
}
