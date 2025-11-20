{ dotfilesPath, ... }:
{
  services.swaync = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile (dotfilesPath + "/swaync/config.json"));
    style = ''
      ${builtins.readFile (dotfilesPath + "/swaync/style.css")}
    '';
  };
}
