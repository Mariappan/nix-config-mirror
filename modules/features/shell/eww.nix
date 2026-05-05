{
  flake.modules.homeManager.eww =
    { ... }:
    {
      nixma.imported.eww = true;

      programs.eww.enable = true;
      programs.eww.enableFishIntegration = true;
    };
}
