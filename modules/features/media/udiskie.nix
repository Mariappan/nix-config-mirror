{
  flake.modules.homeManager.udiskie =
    { ... }:
    {
      nixma.imported.udiskie = true;

      services.udiskie.enable = true;
    };
}
