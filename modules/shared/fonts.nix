{ pkgs, ... }:
{
  # Shared fonts configuration across NixOS and Darwin
  fonts.packages = with pkgs; [
    # Maple Mono (Ligature TTF unhinted)
    maple-mono.truetype
    maple-mono.NF-unhinted
    # Victor Mono
    victor-mono
    # MesloLGS NF font
    nixma.meslolgsnf-font
    # Script12 BT font with custom sizing
    nixma.script12bt-font
  ];
}
