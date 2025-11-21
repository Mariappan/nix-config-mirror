{ ... }:
{
  programs.foot.enable = true;
  programs.foot.server.enable = true;
  programs.foot.settings = {
    main = {
      dpi-aware = "no";
      font = "Victor Mono Semibold:size=10,MesloLGS NF";
      font-italic = "Script12 BT:size=12";
      underline-offset = "3px";
      pad = "5x5 center";
      selection-target = "both";
    };
    mouse = {
      hide-when-typing = "yes";
    };
    scrollback = {
      lines = 10000;
    };
  };
}
