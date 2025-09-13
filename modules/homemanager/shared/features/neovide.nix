{ pkgs, ... }:
{
  programs.neovide = {
    enable = true;
    settings = {
      font = {
        normal = [
          "Maple Mono Light"
          "MesloLGS NF"
        ];
        size = 10.0;
        bold_italic = [
          {
            family = "Script12 BT";
            style = "Bold Italic";
          }
        ];
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
