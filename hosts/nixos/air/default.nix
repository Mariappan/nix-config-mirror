{
  lib,
  pkgs,
  home-manager,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./users.nix
    ../../../modules/nixos/common.nix
    ../../../modules/nixos/bluetooth.nix
    ../../../modules/nixos/manpages.nix
    ../../../modules/nixos/niri.nix
    ../../../modules/nixos/laptop.nix
    ../../../modules/nixos/sound.nix
    ../../../modules/nixos/docker.nix
    ../../../modules/nixos/1password.nix
    ../../../modules/nixos/virtualbox.nix
    ../../../modules/nixos/screenrecorder.nix
    ../../../modules/nixos/fprint.nix
  ];

  # Set the primary user for this system
  nixma.primaryUser = "maari";

  programs.yubikey-touch-detector.enable = true;

  # System configs
  networking.hostName = "air";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  networking.networkmanager = {
    dispatcherScripts = [
      {
        source = "${pkgs.nixma.wired_wifi_toggle}/bin/wired_wifi_toggle";
        type = "basic";
      }
    ];
  };

  # Timezone
  time.timeZone = "Asia/Singapore";

  # Enable fstrim for SSD
  services.fstrim.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P"
  ];

  # To avoid HHKB sending Power key on ignoring "Fn+Esc"
  services.logind.settings.Login.HandlePowerKey = "ignore";

  # Lock when yubikey is plugged out
  services.udev.extraRules = ''
    ACTION=="remove",\
     ENV{ID_BUS}=="usb",\
     ENV{ID_MODEL_ID}=="0407",\
     ENV{ID_VENDOR_ID}=="1050",\
     ENV{ID_VENDOR}=="Yubico",\
     RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';

  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.vscode.enable = true;
  programs.vscode.extensions = with pkgs.vscode-extensions; [
    ms-vsliveshare.vsliveshare
    rust-lang.rust-analyzer
  ];
}
