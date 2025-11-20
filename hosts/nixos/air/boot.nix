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

  # Unstable default kernel is 6.12
  # Use latest if latest kernel is needed
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.blacklistedKernelModules = [ "kvm-intel" ];

  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "8G";

  boot.kernelParams = [
    "ip=dhcp"
    "boot.shell_on_fail"
  ];

  boot.initrd = {
    availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "r8152"
      "rtsx_pci_sdmmc"
    ];
    kernelModules = [ ];
    systemd = {
      enable = true;
      users.root.shell = lib.mkIf (config.boot.initrd.systemd.enable) "/bin/systemd-tty-ask-password-agent";
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
