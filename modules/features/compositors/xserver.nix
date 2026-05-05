{
  flake.modules.nixos.xserver =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.nixma.nixos.xserver;
    in
    {
      options.nixma.nixos.xserver.enable = lib.mkEnableOption "X11 windowing system with US keymap";

      config = lib.mkIf cfg.enable {
        services.xserver = {
          enable = true;

          # Configure keymap in X11
          xkb = {
            layout = "us";
            variant = "";
          };
        };

        environment.systemPackages = [
          pkgs.libnotify
        ];
      };
    };
}
