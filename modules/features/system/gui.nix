{ self, ... }:
{
  flake.modules.nixos.gui = {
    imports = with self.modules.nixos; [
      sound
      screenrecorder
      plymouth
    ];
  };
}
