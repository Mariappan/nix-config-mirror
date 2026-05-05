{
  flake.modules.nixos.shared-fonts =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        maple-mono.truetype
        maple-mono.NF-unhinted
        victor-mono
        nixma.meslolgsnf-font
        nixma.script12bt-font
        (google-fonts.override {
          fonts = [
            "Stardos Stencil"
            "Oswald"
          ];
        })
      ];
    };

  flake.modules.darwin.shared-fonts =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        maple-mono.truetype
        maple-mono.NF-unhinted
        victor-mono
        nixma.meslolgsnf-font
        nixma.script12bt-font
        (google-fonts.override {
          fonts = [
            "Stardos Stencil"
            "Oswald"
          ];
        })
      ];
    };
}
