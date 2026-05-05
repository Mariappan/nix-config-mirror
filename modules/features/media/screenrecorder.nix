{
  flake.modules.nixos.screenrecorder =
    { ... }:
    {
      programs.gpu-screen-recorder.enable = true;
    };
}
