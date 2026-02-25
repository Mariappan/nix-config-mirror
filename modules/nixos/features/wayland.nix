{ pkgs, lib, ... }:
{
  imports = [
    ../../shared/fonts.nix
  ];

  nixma.nixos.wayland-dm.enable = true;

  programs.dconf.enable = true;

  # Ref: https://www.reddit.com/r/NixOS/comments/171mexa/polkit_on_hyprland/
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  services.udisks2.enable = true;

  # polkit 127's socket-activated helper runs with strict sandboxing that
  # blocks pam_u2f.so (ProtectHome=yes hides u2f_keys, PrivateDevices=yes
  # hides /dev/hidraw*). Relax just enough for YubiKey auth to work.
  # Ref: https://github.com/NixOS/nixpkgs/pull/486044
  systemd.services."polkit-agent-helper@".serviceConfig = {
    ProtectHome = lib.mkForce "read-only";
    PrivateDevices = lib.mkForce false;
    DeviceAllow = lib.mkForce [
      "/dev/null rw"
      "/dev/urandom r"
      "char-hidraw rw"
    ];
    StandardError = "journal";
  };

  security.pam.services = {
    # GreetD - regreet uses separate `greetd` PAM context
    # Disable Fingerprint/Yubikey for allowing to unlock Keyring
    greetd = {
      enableGnomeKeyring = true;
      u2fAuth = false;
      fprintAuth = false;
    };
    # noctalia-shell uses login pam context
    # for system-lock
    login = {
      enableGnomeKeyring = true;
    };
    cthulock = {
      unixAuth = true;
      u2fAuth = true;
    };
    hyprlock.u2fAuth = true;
    polkit-1.u2fAuth = true;
  };

  xdg.terminal-exec.enable = true;
  xdg.terminal-exec.settings = {
    default = [
      "com.mitchellh.ghostty"
      "org.wezfurlong.wezterm.desktop"
      "foot"
    ];
  };

  environment.systemPackages = [
    pkgs.libnotify
  ];
}
