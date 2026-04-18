{
  flake.modules.homeManager.walker =
    { ... }:
    {
      services.walker.enable = true;
      services.walker.systemd.enable = true;
    };
}
