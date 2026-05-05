{
  flake.modules.nixos.yubikey =
    { pkgs, ... }:
    {
      # Smart card daemon for PIV / PKCS#11 access.
      services.pcscd.enable = true;

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
