{
  flake.modules.nixos.screenrecorder =
    { ... }:
    {
      nixma.nixos.imported.screenrecorder = true;

      programs.gpu-screen-recorder.enable = true;
    };
}
