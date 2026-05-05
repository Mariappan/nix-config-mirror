{
  flake.modules.nixos.nvidia =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.nixma.nixos.nvidia;
    in
    {
      options.nixma.nixos.nvidia.mode = lib.mkOption {
        type = lib.types.enum [
          "enable"
          "blacklist"
        ];
        default = "enable";
        description = "Whether to enable nvidia drivers or blacklist them for battery life";
      };

      config = lib.mkMerge [
        (lib.mkIf (cfg.mode == "enable") {
          services.xserver.videoDrivers = [ "nvidia" ];

          hardware.graphics = {
            enable = true;
          };

          hardware.nvidia = {
            modesetting.enable = true;
            nvidiaPersistenced = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = true;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.stable;
          };
        })

        (lib.mkIf (cfg.mode == "blacklist") {
          boot.extraModprobeConfig = ''
            blacklist nouveau
            options nouveau modeset=0
          '';

          services.udev.extraRules = ''
            # Remove NVIDIA USB xHCI Host Controller devices, if present
            ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

            # Remove NVIDIA USB Type-C UCSI devices, if present
            ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

            # Remove NVIDIA Audio devices, if present
            ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

            # Remove NVIDIA VGA/3D controller devices
            ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
          '';

          boot.blacklistedKernelModules = [
            "nouveau"
            "nvidia"
            "nvidia_drm"
            "nvidia_modeset"
          ];
        })
      ];
    };
}
