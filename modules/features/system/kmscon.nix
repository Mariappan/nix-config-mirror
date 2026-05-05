{
  flake.modules.nixos.kmscon =
    { ... }:
    {
      nixma.nixos.imported.kmscon = true;

      services.kmscon = {
        enable = true;
        hwRender = true;
        term = "xterm-256color";
        extraConfig = "font-size=14";
      };
    };
}
