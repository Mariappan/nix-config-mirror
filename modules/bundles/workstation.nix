{ self, ... }:
{
  flake.modules.nixos.workstation = {
    nixma.nixos.imported.workstation = true;

    imports = [
      self.modules.nixos.wayland # imports gui (sound, plymouth, screenrecorder, _1password, zen-browser), wayland-dm, nautilus, shared-fonts
      self.modules.nixos.desktop # NixOS branch — hidraw udev rule
      self.modules.nixos.veila
      self.modules.nixos.documentation
    ];
  };
}
