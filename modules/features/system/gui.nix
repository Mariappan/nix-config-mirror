{ self, ... }:
{
  flake.modules.nixos.gui = {
    nixma.nixos.imported.gui = true;

    imports = [
      self.modules.nixos.sound
      self.modules.nixos.screenrecorder
      self.modules.nixos.plymouth
      self.modules.nixos._1password
      self.modules.nixos.zen-browser
    ];
  };
}
