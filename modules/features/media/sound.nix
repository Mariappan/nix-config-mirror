{
  flake.modules.nixos.sound =
    { config, lib, ... }:
    let
      cfg = config.nixma.nixos.sound;
    in
    {
      options.nixma.nixos.sound.enable =
        lib.mkEnableOption "PipeWire audio stack (with ALSA + PulseAudio compatibility)";

      config = lib.mkIf cfg.enable {
        security.rtkit.enable = true;
        services.pulseaudio.enable = false;
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          wireplumber.enable = true;
        };
      };
    };
}
