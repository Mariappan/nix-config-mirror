{ self, inputs, ... }:
{
  flake.modules.nixos.workstation = {
    nixma.nixos.imported.workstation = true;

    imports = [
      self.modules.nixos.wayland
      self.modules.nixos.desktop
      self.modules.nixos.veila
      self.modules.nixos.documentation
      # kmscon pulls in heavier libraries like llvm, graphics
      self.modules.nixos.kmscon
    ];

    # Workstation-only HM modules
    home-manager.sharedModules = [
      self.modules.homeManager.desktop
      self.modules.homeManager.helix
      inputs.nix-index-database.homeModules.nix-index
    ];
  };
}
