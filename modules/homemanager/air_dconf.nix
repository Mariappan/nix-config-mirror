# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{home-manager, ...}:
with home-manager.lib.hm.gvariant; {
  dconf.settings = {
    "org/gnome/Console" = {
      custom-font = "Victor Mono 10";
      last-window-maximised = false;
      last-window-size = mkTuple [1341 981];
      use-system-font = false;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/desktop/notifications" = {
      application-children = ["org-gnome-epiphany" "google-chrome" "org-gnome-nautilus" "slack" "gnome-power-panel" "org-gnome-console"];
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/google-chrome" = {
      application-id = "google-chrome.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-console" = {
      application-id = "org.gnome.Console.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/slack" = {
      application-id = "slack.desktop";
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/portal/filechooser/google-chrome" = {
      last-folder-path = "/home/maari/download";
    };

    "org/gnome/shell" = {
      favorite-apps = ["org.wezfurlong.wezterm.desktop" "google-chrome.desktop" "slack.desktop" "obsidian.desktop" "1password.desktop" "org.gnome.Nautilus.desktop"];
    };

    "org/gnome/shell/world-clocks" = {
      locations = [];
    };

    "org/gnome/login-screen" = {
      enable-fingerprint-authentication = false;
    };
  };
}
