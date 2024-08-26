{pkgs, ...}: let
  pkg_ddlm = pkgs.rustPlatform.buildRustPackage rec {
    pname = "ddlm";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "deathowl";
      repo = "ddlm";
      rev = "8a7213909c7a7f4672a6db05ca5fdd0b37c5ceeb";
      sha256 = "sha256-V3084fBpuCkJ9N0Rw6uBvjQPtZi2BXGxlvmEYH7RahE=";
    };

    cargoSha256 = "sha256-DGq+s5nStfQ0BYl3VBsf1uDbLpa+w0zjTMc+TCIiVF0=";
    meta = with pkgs.stdenv.lib; {
      homepage = "https://github.com/deathowl/ddlm";
    };
  };
in {
  imports = [./xserver.nix];

  programs.hyprland.enable = true;
  # Enable it for debug package
  # programs.hyprland.package = pkgs.hyprland.override {
  #   debug = true;
  # };
  programs.wshowkeys.enable = true;
  programs.dconf.enable = true;

  services.greetd.enable = true;
  services.greetd.package = pkgs.greetd.tuigreet;
  services.greetd.settings = {
    default_session = {
      # command = "${pkg_ddlm}/bin/ddlm --target hyprland";
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd hyprland";
    };
  };

  users.users.greeter.extraGroups = ["video" "input"];

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

  services.udev.extraRules = ''
    ACTION=="remove",\
     ENV{ID_BUS}=="usb",\
     ENV{ID_MODEL_ID}=="0407",\
     ENV{ID_VENDOR_ID}=="1050",\
     ENV{ID_VENDOR}=="Yubico",\
     RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "xdph"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        "org.freedesktop.portal.FileChooser" = ["xdg-desktop-portal-gtk"];
      };
    };
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };

  environment.systemPackages = [
    pkg_ddlm
  ];
}
