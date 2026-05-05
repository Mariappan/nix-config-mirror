{
  flake.modules.nixos.plymouth =
    { pkgs, ... }:
    {
      boot.plymouth = {
        enable = true;
        theme = "rings";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = [ "rings" ];
          })
        ];
      };

      # Boot aesthetics for a clean Plymouth experience
      boot.kernelParams = [
        "quiet"
        "splash"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];

      boot.consoleLogLevel = 3;
      boot.initrd.verbose = false;
    };
}
