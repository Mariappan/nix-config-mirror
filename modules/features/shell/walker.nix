{
  flake.modules.homeManager.walker =
    { ... }:
    {
      nixma.imported.walker = true;

      services.walker.enable = true;
      services.walker.systemd.enable = true;
    };
}
