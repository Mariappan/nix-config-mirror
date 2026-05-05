{
  flake.modules.nixos.shared-shells =
    { pkgs, ... }:
    {
      nixma.nixos.imported.shared-shells = true;

      programs.zsh.enable = true;
      programs.fish.enable = true;

      environment.shells = [
        pkgs.bashInteractive
        pkgs.zsh
        pkgs.fish
      ];
    };

  flake.modules.darwin.shared-shells =
    { pkgs, ... }:
    {
      nixma.darwin.imported.shared-shells = true;

      programs.zsh.enable = true;
      programs.fish.enable = true;

      environment.shells = [
        pkgs.bashInteractive
        pkgs.zsh
        pkgs.fish
      ];
    };
}
