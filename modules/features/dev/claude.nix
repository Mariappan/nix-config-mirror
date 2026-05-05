{
  flake.modules.homeManager.claude =
    { pkgs, ... }:
    {
      nixma.imported.claude = true;

      home.packages = [
        pkgs.claude-code
        pkgs.nodejs
        pkgs.bun
      ];
    };
}
