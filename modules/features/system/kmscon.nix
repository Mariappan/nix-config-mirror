{
  flake.modules.nixos.kmscon =
    { ... }:
    {
      nixma.nixos.imported.kmscon = true;

      services.kmscon = {
        enable = true;
        config = {
          hwaccel = true;
          term = "xterm-256color";
          font-size = 14;
        };
      };
    };
}
