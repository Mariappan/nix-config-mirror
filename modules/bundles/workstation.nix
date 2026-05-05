{ self, inputs, ... }:
{
  flake.modules.nixos.workstation = {
    nixma.nixos.imported.workstation = true;

    imports = [
      self.modules.nixos.wayland # imports gui (sound, plymouth, screenrecorder, _1password, zen-browser), wayland-dm, nautilus, shared-fonts
      self.modules.nixos.desktop # NixOS branch — hidraw udev rule
      self.modules.nixos.veila
      self.modules.nixos.documentation
      # kmscon pulls in heavier libraries like llvm, graphics
      self.modules.nixos.kmscon
    ];

    # Workstation-only HM modules (heavier closure: neovim, tmux, helix, nix-index DB).
    home-manager.sharedModules = [
      self.modules.homeManager.desktop
      self.modules.homeManager.helix
      inputs.nix-index-database.homeModules.nix-index
    ];
  };
}
