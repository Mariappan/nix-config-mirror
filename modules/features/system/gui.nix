{
  flake.modules.nixos.gui =
    { config, lib, ... }:
    let
      cfg = config.nixma.nixos.gui;
    in
    {
      options.nixma.nixos.gui.enable = lib.mkOption {
        type = lib.types.bool;
        default = lib.elem "workstation" config.nixma.nixos.roles;
        description = "Graphical session bundle (audio, plymouth, screen recorder, browser, 1password).";
      };

      config = lib.mkIf cfg.enable {
        nixma.nixos.sound.enable = lib.mkDefault true;
        nixma.nixos.plymouth.enable = lib.mkDefault true;
        nixma.nixos.screenrecorder.enable = lib.mkDefault true;
        nixma.nixos.zen-browser.enable = lib.mkDefault true;
        nixma.nixos._1password.enable = lib.mkDefault true;
      };
    };
}
