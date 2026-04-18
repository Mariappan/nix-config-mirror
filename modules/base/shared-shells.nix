{
  flake.modules.nixos.shared-shells = { pkgs, ... }: {
    programs.zsh.enable = true;
    programs.fish.enable = true;

    environment.shells = [
      pkgs.bashInteractive
      pkgs.zsh
      pkgs.fish
    ];
  };

  flake.modules.darwin.shared-shells = { pkgs, ... }: {
    programs.zsh.enable = true;
    programs.fish.enable = true;

    environment.shells = [
      pkgs.bashInteractive
      pkgs.zsh
      pkgs.fish
    ];
  };
}
