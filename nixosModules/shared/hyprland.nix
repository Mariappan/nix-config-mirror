{pkgs, ...}: {
  imports = [./xserver.nix];

  programs.hyprland.enable = true;
  programs.wshowkeys.enable = true;

  services.greetd.enable = true;
  services.greetd.package = pkgs.greetd.tuigreet;
  services.greetd.settings = {
    default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd hyprland";
    };
  };
}
