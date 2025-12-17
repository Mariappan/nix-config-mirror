{
  config,
  ...
}:
{
  xdg.enable = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;

  xdg.userDirs.desktop = "${config.home.homeDirectory}/desktop";
  xdg.userDirs.documents = "${config.home.homeDirectory}/documents";
  xdg.userDirs.download = "${config.home.homeDirectory}/downloads";
  xdg.userDirs.music = "${config.home.homeDirectory}/media/music";
  xdg.userDirs.pictures = "${config.home.homeDirectory}/pictures";
  xdg.userDirs.videos = "${config.home.homeDirectory}/media/video";
  xdg.userDirs.templates = "${config.home.homeDirectory}/documents/.templates";
  xdg.userDirs.publicShare = "${config.home.homeDirectory}/documents/shared";

  xdg.cacheHome = "${config.home.homeDirectory}/.cache";
  xdg.configHome = "${config.home.homeDirectory}/.config";

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = "neovide.desktop";
  };

}
