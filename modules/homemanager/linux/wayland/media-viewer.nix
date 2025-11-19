{ pkgs, ... }:
{

  programs.mpv.enable = true;
  programs.imv.enable = true;

  xdg.mimeApps.defaultApplications = {
    "image/*" = "imv.desktop";
    "image/gif" = "imv.desktop";
  };
}
