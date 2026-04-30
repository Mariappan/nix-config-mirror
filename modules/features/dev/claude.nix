{
  flake.modules.homeManager.claude = { pkgs, ... }: {
    home.packages = [
      pkgs.claude-code
      pkgs.nodejs
      pkgs.bun
    ];
  };
}
