{
  flake.modules.nixos.kmscon = { ... }: {
    services.kmscon = {
      enable = true;
      hwRender = true;
      term = "xterm-256color";
      extraConfig = "font-size=14";
    };
  };
}
