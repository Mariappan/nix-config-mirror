{ self, ... }:
{
  flake.modules.nixos.gui = {
    imports = [
      self.modules.nixos.sound
      self.modules.nixos.plymouth
      self.modules.nixos.screenrecorder
      self.modules.nixos._1password
      self.modules.nixos.zen-browser
    ];
  };
}
