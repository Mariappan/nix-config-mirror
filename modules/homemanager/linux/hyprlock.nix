{ dotfilesPath, ... }:
{
  programs.hyprlock = {
    enable = true;
    extraConfig = ''
      ${builtins.readFile (dotfilesPath + "/hypr/hyprlock.conf")}
    '';
  };
}
