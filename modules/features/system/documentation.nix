{
  flake.modules.nixos.documentation =
    { pkgs, ... }:
    {
      documentation.enable = true;

      # Workstation man-page corpora.
      environment.systemPackages = [
        pkgs.man-pages
        pkgs.man-pages-posix
      ];
    };
}
