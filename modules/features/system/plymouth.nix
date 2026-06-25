{
  flake.modules.nixos.plymouth =
    { pkgs, ... }:
    {
      nixma.nixos.imported.plymouth = true;

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
        # Hide the blinking text cursor on the bare console. During the
        # greetd handoff (greeter compositor exits -> niri grabs DRM) the
        # kernel framebuffer console is briefly visible; no cursor = cleaner.
        "vt.global_cursor_default=0"
      ];

      boot.consoleLogLevel = 3;
      boot.initrd.verbose = false;
    };
}
