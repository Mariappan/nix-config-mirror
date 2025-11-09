{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported devices
        Experimental = true;
        FastConnectable = false; # increased power consumption on true
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
}
