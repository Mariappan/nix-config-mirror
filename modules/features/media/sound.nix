{
  flake.modules.nixos.sound =
    { ... }:
    {
      nixma.nixos.imported.sound = true;

      # Enable sound with pipewire.
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
}
