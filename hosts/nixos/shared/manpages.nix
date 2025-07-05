{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.man-pages
    pkgs.man-pages-posix
  ];
}
