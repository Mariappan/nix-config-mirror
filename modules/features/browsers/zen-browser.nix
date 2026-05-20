{ self, inputs, ... }:
{
  flake.modules.nixos.zen-browser =
    { ... }:
    {
      nixma.nixos.imported.zen-browser = true;

      imports = [ self.modules.nixos._1password ];

      nixma.nixos._1password.allowedBrowsers = [
        ".zen-wrapped"
        "zen-twilight"
        "zen"
      ];

      home-manager.sharedModules = [ self.modules.homeManager.zen-browser ];
    };

  flake.modules.homeManager.zen-browser =
    { pkgs, ... }:
    {
      nixma.imported.zen-browser = true;

      imports = [
        inputs.zen-browser.homeModules.twilight
      ];

      programs.zen-browser.enable = true;

      # WebSerial polyfill: ship the native messaging host binary, and expose
      # its NMH manifest at the ~/.mozilla path Zen scans (zen-browser flake's
      # wrapper doesn't honor NIX_MOZ_NATIVE_MESSAGING_HOSTS_PATH like wrapped
      # firefox does). The .xpi extension is installed separately from
      # addons.mozilla.org by the user.
      home.packages = [ pkgs.nixma.firefox-webserial ];
      home.file.".mozilla/native-messaging-hosts/io.github.kuba2k2.webserial.json".source =
        "${pkgs.nixma.firefox-webserial}/lib/mozilla/native-messaging-hosts/io.github.kuba2k2.webserial.json";

      xdg.mimeApps.defaultApplications = {
        "default-web-browser" = "zen-twilight.desktop";
        "application/pdf" = "zen-twilight.desktop";
        "application/rdf+xml" = "zen-twilight.desktop";
        "application/rss+xml" = "zen-twilight.desktop";
        "application/xhtml+xml" = "zen-twilight.desktop";
        "application/xhtml_xml" = "zen-twilight.desktop";
        "application/xml" = "zen-twilight.desktop";
        "x-scheme-handler/http" = "zen-twilight.desktop";
        "x-scheme-handler/https" = "zen-twilight.desktop";
        "x-scheme-handler/about" = "zen-twilight.desktop";
        "x-scheme-handler/unknown" = "zen-twilight.desktop";
      };
    };
}
