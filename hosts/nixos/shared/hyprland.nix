{ pkgs, ... }:
{
  imports = [ ./xserver.nix ];

  programs.regreet.enable = true;
  programs.regreet = {
    settings = {
      gtk.application_prefer_dark_theme = true;
    };
    cursorTheme.name = "Adwaita";
    cursorTheme.package = pkgs.adwaita-icon-theme;
    theme.name = "adw-gtk3-dark";
    theme.package = pkgs.adw-gtk3;
  };
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM  = true;
  # Enable it for debug package
  # programs.hyprland.package = pkgs.hyprland.override {
  #   debug = true;
  # };
  programs.wshowkeys.enable = true;
  programs.dconf.enable = true;

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

  fonts.packages = with pkgs; [
    # Maple Mono (Ligature TTF unhinted)
    maple-mono.truetype
    maple-mono.NF-unhinted
    # MesloLGS NF font
    nixma.meslolgsnf-font
    # Script12 BT font with custom sizing
    nixma.script12bt-font
  ];

  environment.systemPackages = [
    pkgs.nixma.ddlm
  ];
}
