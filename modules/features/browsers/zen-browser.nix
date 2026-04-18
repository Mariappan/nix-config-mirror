{ self, inputs, ... }: {
  flake.modules.nixos.zen-browser = { ... }: {
    nixma.nixos."1password".allowedBrowsers = [
      ".zen-wrapped"
      "zen-twilight"
      "zen"
    ];

    home-manager.sharedModules = [ self.modules.homeManager.zen-browser ];
  };

  flake.modules.homeManager.zen-browser = { ... }: {
    imports = [
      inputs.zen-browser.homeModules.twilight
    ];

    programs.zen-browser.enable = true;

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
