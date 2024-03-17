{ config, lib, pkgs, ... }:

{
  # GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  boot.kernelParams = [ "ip=dhcp" ];

  boot.initrd = {
    availableKernelModules = [ "vmxnet3" "virtio-pci" ];
    systemd = {
      enable = true;
      users.root.shell = lib.mkIf (config.boot.initrd.systemd.enable) "/bin/systemd-tty-ask-password-agent";
    };
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 22;
        authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
        hostKeys = [ "/etc/secrets/initrd/ssh_host_rsa_key" ];
        shell = lib.mkIf (!config.boot.initrd.systemd.enable) "/bin/cryptsetup-askpass";
      };
    };
  };
}
