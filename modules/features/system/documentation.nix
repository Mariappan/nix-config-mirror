{
  flake.modules.nixos.documentation =
    { pkgs, ... }:
    {
      nixma.nixos.imported.documentation = true;

      documentation.enable = true;

      # Workstation man-page corpora.
      environment.systemPackages = [
        pkgs.man-pages
        pkgs.man-pages-posix
      ];
    };
}
