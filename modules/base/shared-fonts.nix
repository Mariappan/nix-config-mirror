{
  flake.modules.nixos.shared-fonts =
    { config, lib, pkgs, ... }:
    let
      cfg = config.nixma.nixos.shared-fonts;
    in
    {
      options.nixma.nixos.shared-fonts.enable = lib.mkOption {
        type = lib.types.bool;
        default = lib.elem "workstation" config.nixma.nixos.roles;
        description = "Install Maple Mono, Victor Mono, NF, and selected Google Fonts.";
      };

      config = lib.mkIf cfg.enable {
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
