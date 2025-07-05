{
  pkgs,
  ...
}: {
  nixma.core.enable = true;
  home.packages = [
    pkgs.helloworld
  ];
}
