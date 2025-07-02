{pkgs, ...}: {
  imports = [./xserver.nix];

  programs.hyprland.enable = true;
  # Enable it for debug package
  # programs.hyprland.package = pkgs.hyprland.override {
  #   debug = true;
  # };
  programs.wshowkeys.enable = true;
  programs.dconf.enable = true;

  services.displayManager.ly.enable = true;

  # Ref: https://www.reddit.com/r/NixOS/comments/171mexa/polkit_on_hyprland/
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  security.pam.services = {
    login = {
      u2fAuth = true;
      enableGnomeKeyring = true;
    };
    hyprlock.u2fAuth = true;
    polkit-1.u2fAuth = true;
  };

  xdg.terminal-exec.enable = true;
  xdg.terminal-exec.settings = {
      Hyprland = [
          "org.wezfurlong.wezterm.desktop"
      ];
  };

  services.udev.extraRules = ''
    ACTION=="remove",\
     ENV{ID_BUS}=="usb",\
     ENV{ID_MODEL_ID}=="0407",\
     ENV{ID_VENDOR_ID}=="1050",\
     ENV{ID_VENDOR}=="Yubico",\
     RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';

  environment.systemPackages = [
    pkgs.nixma.ddlm
  ];
}
