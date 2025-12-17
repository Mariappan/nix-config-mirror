{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen
  ];

  # Set the primary user for this system
  nixma.nixos.params.primaryUser = "maari";

  # Configure users
  nixma.nixos.users.root.enable = true;
  nixma.nixos.users.maari = {
    enable = true;
    email = "142216110+kp-mariappan-ramasamy@users.noreply.github.com";
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P"
    ];
    bundle = "air";
    gitSigningKey = "3B7DA4A8AF8C211443B571A2AD921C91A406F32D";
    gitSignByDefault = true;
  };

  # Hardware configuration
  nixma.nixos.hardware = {
    work.enable = true;
    swap.enable = true;
    cpu.vendor = "intel";
  };

  # Boot configuration
  nixma.nixos.boot = {
    kernelPackage = "default";
    kernelVersion = "6.17";
    blacklistedKernelModules = [ "kvm-intel" ];
    tmpfs = {
      enable = true;
      size = "8G";
    };
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "r8152"
      "rtsx_pci_sdmmc"
    ];
  };

  # Enable nixos features
  nixma.nixos = {
    "1password".enable = true;
    zen-browser.enable = true;
    vivaldi.enable = true;
    bluetooth.enable = true;
    docker.enable = true;
    fprint.enable = true;
    laptop.enable = true;
    manpages.enable = true;
    niri.enable = true;
    plymouth.enable = true;
    screenrecorder.enable = true;
    sound.enable = true;
    virtualbox.enable = true;
  };

  # System configs
  networking.hostName = "air";

  # Timezone
  time.timeZone = "Asia/Singapore";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.fwupd.enable = true;

  programs.yubikey-touch-detector.enable = true;
  programs.vscode.enable = true;
  programs.vscode.extensions = with pkgs.vscode-extensions; [
    ms-vsliveshare.vsliveshare
    rust-lang.rust-analyzer
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
}
