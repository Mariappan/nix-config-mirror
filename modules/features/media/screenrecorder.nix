{
  flake.modules.nixos.screenrecorder =
    { config, lib, ... }:
    let
      cfg = config.nixma.nixos.screenrecorder;
    in
    {
      options.nixma.nixos.screenrecorder.enable = lib.mkEnableOption "gpu-screen-recorder system service";

      config = lib.mkIf cfg.enable {
        programs.gpu-screen-recorder.enable = true;
      };
    };
}
