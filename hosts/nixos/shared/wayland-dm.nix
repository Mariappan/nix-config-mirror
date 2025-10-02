{ pkgs, ... }:
{
  programs.regreet.enable = true;
  programs.regreet = {
    settings = {
      gtk.application_prefer_dark_theme = true;
    };
    cursorTheme.name = "Adwaita";
    cursorTheme.package = pkgs.adwaita-icon-theme;
    theme.name = "adw-gtk3-dark";
    theme.package = pkgs.adw-gtk3;
  };
}
