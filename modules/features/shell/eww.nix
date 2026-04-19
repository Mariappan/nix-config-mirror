{
  flake.modules.homeManager.eww =
    { ... }:
    {
      programs.eww.enable = true;
      programs.eww.enableFishIntegration = true;
    };
}
