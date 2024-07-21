{pkgs, ...}: {
  imports = [./xserver.nix];

  programs.hyprland.enable = true;
  programs.wshowkeys.enable = true;

  services.logind.powerKey = "ignore";

  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.lidSwitchDocked = "ignore";

  services.greetd.enable = true;
  services.greetd.package = pkgs.greetd.tuigreet;
  services.greetd.settings = {
    default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd hyprland";
    };
  };
}
