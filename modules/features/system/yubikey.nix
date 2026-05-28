{
  flake.modules.nixos.yubikey =
    { pkgs, ... }:
    {
      nixma.nixos.imported.yubikey = true;

      # PC/SC smart-card daemon. Mediates CCID access for PIV / PKCS#11
      # consumers (ykman piv|oath, browser client certs, pam_pkcs11, OpenVPN
      # cert auth, etc.).
      #
      # Disabled here because pcscd opens the CCID interface exclusively,
      # which blocks gpg's scdaemon ("selecting card failed: No such device").
      # GPG/SSH-via-gpg-agent talk to the YubiKey's CCID interface directly,
      # and pam_u2f / FIDO2 use the separate USB HID interface, so neither
      # path needs pcscd. Re-enable if PIV or PKCS#11 tooling is required.
      services.pcscd.enable = false;

      # Enable U2F PAM module — also triggers the upstream polkit-agent-helper@
      # sandbox relaxation needed for pam_u2f.so to read /dev/hidraw* and
      # ~/.config/Yubico/u2f_keys.
      security.pam.u2f.enable = true;

      # OpenSC: drivers + utilities (opensc-tool, pkcs11-tool).
      environment.systemPackages = [ pkgs.opensc ];

      # Desktop notification on touch requests for SSH/GPG over YubiKey.
      programs.yubikey-touch-detector.enable = true;

      # Lock all sessions when the YubiKey is unplugged.
      services.udev.extraRules = ''
        ACTION=="remove",\
         ENV{ID_BUS}=="usb",\
         ENV{ID_MODEL_ID}=="0407",\
         ENV{ID_VENDOR_ID}=="1050",\
         ENV{ID_VENDOR}=="Yubico",\
         RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
      '';
    };
}
