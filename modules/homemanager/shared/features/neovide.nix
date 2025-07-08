{ pkgs, ... }:
{
  programs.neovide = {
    enable = true;
    settings = {
      font = {
        normal = [
          "Victor Mono"
          "MesloNGS NF"
        ];
        size = 10.0;
        italic = [
          {
            family = "Script12 BT";
            style = "SemiBold Italic";
          }
        ];
      };
      box-drawing = {
        mode = "native";
      };
    };
  };
}
