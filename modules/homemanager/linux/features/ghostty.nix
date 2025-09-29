{ pkgs, lib, ... }:
{
  programs.ghostty.enable = true;
  programs.ghostty.enableFishIntegration = true;
  programs.ghostty.settings = {
    theme = "Gruvbox Dark";

    font-family = [
      "Maple Mono"
      "MesloLGS NF"
    ];
    font-family-bold = [
      "Maple Mono Bold"
      "MesloLGS NF"
    ];
    font-family-italic = [
      "Script12 BT"
      "MesloLGS NF"
    ];
    font-family-bold-italic = [
      "Script12 BT"
      "MesloLGS NF"
    ];

    font-size = 10.5;
    adjust-underline-position = 4;
    clipboard-read = "allow";
    clipboard-write = "allow";
    clipboard-trim-trailing-spaces = true;

    background-blur = true;
    background-opacity = 0.9;

    app-notifications = "clipboard-copy";
    window-padding-x = "5,5";
    quick-terminal-position = "top";
    quick-terminal-size = "35%,75%";

    keybind = [
      # Claude shift enter to enter
      "shift+enter=text:\x1b\r"
      "global:ctrl+grave_accent=toggle_quick_terminal"
    ];
  };
}
