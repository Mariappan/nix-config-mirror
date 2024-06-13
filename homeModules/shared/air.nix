{pkgs, ...}: {
  home.packages = [
    pkgs.slack
    pkgs.obsidian
    pkgs.ipcalc
  ];
}
