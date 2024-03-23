{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # SET IT BEFORE INTEGRATING flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
        hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
        shell = lib.mkIf (!config.boot.initrd.systemd.enable) "/bin/cryptsetup-askpass";
      };
    };
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [ vim wget ];

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P"
  ];

  system.stateVersion = "23.11"; # Did you read the comment?
}

