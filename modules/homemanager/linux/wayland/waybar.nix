{
  pkgs,
  dotfilesPath,
  ...
}:
let
  pkg_togglewifi = pkgs.writeScriptBin "waybar_togwifi.sh" (
    builtins.readFile (dotfilesPath + "/waybar/scripts/toggle_wifi.sh")
  );
  pkg_wttrpy = pkgs.writers.writePython3Bin "waybar_wttr.py" { } (
    builtins.readFile (dotfilesPath + "/waybar/scripts/wttr.py")
  );
  togglewifi = "${pkg_togglewifi}/bin/waybar_togwifi.sh";
  wttrpy = "${pkg_wttrpy}/bin/waybar_wttr.py";
in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainbar = builtins.fromJSON (
        builtins.unsafeDiscardStringContext (
          builtins.readFile (
            pkgs.replaceVars (dotfilesPath + "/waybar/config.json") {
              inherit togglewifi wttrpy;
            }
          )
        )
      );
    };
    style = ''
      ${builtins.readFile (dotfilesPath + "/waybar/style.css")}
    '';

    systemd.enable = true;
    systemd.target = "graphical-session.target";
  };

  home.packages = [
    # Keep it so that it is not garbage collected
    pkg_togglewifi
    pkg_wttrpy
  ];
}
