# Nvidia GPU configuration module
# Supports enabling nvidia drivers or blocking them for better battery life
# Blocking config copied from nixos-hardware:
# https://github.com/NixOS/nixos-hardware/blob/497ae1357f1ac97f1aea31a4cb74ad0d534ef41f/common/gpu/nvidia/disable.nix#L1
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
      options.nixma.nixos.nvidia = {
        enable = lib.mkEnableOption "Nvidia GPU module (driver or blacklist)";

        mode = lib.mkOption {
          type = lib.types.enum [
            "enable"
            "blacklist"
          ];
          default = "enable";
          description = "Whether to enable nvidia drivers or blacklist them for battery life";
        };
      };

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          # Enable nvidia drivers
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

          # Blacklist nvidia drivers for battery life
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
        ]
      );
    };
}
