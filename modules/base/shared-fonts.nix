{
  flake.modules.nixos.shared-fonts =
    { pkgs, ... }:
    {
      nixma.nixos.imported.shared-fonts = true;

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
      nixma.darwin.imported.shared-fonts = true;

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
