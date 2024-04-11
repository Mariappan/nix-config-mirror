{config, pkgs, ...}: {
  xdg.enable = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;

  xdg.userDirs.desktop = "${config.home.homeDirectory}/desktop";
  xdg.userDirs.documents = "${config.home.homeDirectory}/documents";
  xdg.userDirs.download = "${config.home.homeDirectory}/download";
  xdg.userDirs.music = "${config.home.homeDirectory}/music";
  xdg.userDirs.pictures = "${config.home.homeDirectory}/pictures";
  xdg.userDirs.videos = "${config.home.homeDirectory}/videos";
  xdg.userDirs.templates = "${config.home.homeDirectory}/templates";
  xdg.userDirs.publicShare = "${config.home.homeDirectory}/shared";

  xdg.cacheHome = "${config.home.homeDirectory}/.cache";
  xdg.configHome = "${config.home.homeDirectory}/.config";
}
