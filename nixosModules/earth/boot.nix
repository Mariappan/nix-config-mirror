{
  config,
  lib,
  pkgs,
  ...
}: {
  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  boot.kernelParams = ["ip=dhcp"];

  boot.initrd = {
    availableKernelModules = [ "virtio_pci" "xhci_pci" "usbhid" "usb_storage" ];
    kernelModules = [];
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
        hostKeys = ["/etc/secrets/initrd/ssh_host_ed25519_key"];
        shell = lib.mkIf (!config.boot.initrd.systemd.enable) "/bin/cryptsetup-askpass";
      };
    };
  };
}
