{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.blacklistedKernelModules = [ ];
  boot.supportedFilesystems = [ "bcachefs" ];

  boot.kernelParams = [ "ip=dhcp" ];

  boot.initrd = {
    availableKernelModules = [
      "virtio_pci"
      "ahci"
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "ehci_pci"
      "nvme"
      "sr_mod"
      "tpm_crb"
      "tpm_tis"
    ];
    kernelModules = [ ];
    systemd = {
      enable = true;
      users.root.shell = lib.mkIf (config.boot.initrd.systemd.enable) "/bin/systemd-tty-ask-password-agent";
    };
    clevis = {
      enable = true;
      useTang = true;
      devices."${config.fileSystems."/".device}".secretFile = ./secret.jwe;
            # devices."${config.fileSystems."/work".device}".secretFile = ./secret.jwe;
    };
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2022;
        authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
        hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
        shell = lib.mkIf (!config.boot.initrd.systemd.enable) "/bin/cryptsetup-askpass";
      };
    };
  };
}
