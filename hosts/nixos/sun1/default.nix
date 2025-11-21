{ ... }:
{
  # Set the primary user for this system
  nixma.nixos.params.primaryUser = "maari";

  # Configure users
  nixma.nixos.users.root.enable = true;
  nixma.nixos.users.maari = {
    enable = true;
    email = "1221719+nappairam@users.noreply.github.com";
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
    ];
    extraGroups = [ "incus-admin" ]; # Added to default groups
    bundle = "sun1";
    gitSignByDefault = false;
  };

  # Hardware configuration
  nixma.nixos.hardware = {
    luks.enable = true;
    work.enable = true;
    swap.enable = true;
    cpu.vendor = "amd";
  };

  # Boot configuration
  nixma.nixos.boot = {
    kernelModules = [ "kvm-amd" ];
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "thunderbolt"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
  };

  # Enable nixos features
  nixma.nixos = {
    "1password".enable = true;
    docker.enable = true;
    headless.enable = true;
    lanzaboote.enable = true;
    manpages.enable = true;
    niri.enable = true;
    screenrecorder.enable = true;
    sound.enable = true;
    virtualbox.enable = true;
  };

  # System configs
  networking.hostName = "sun1";
  # NetworkManager handles DHCP, so useDHCP is not needed
  # networking.useDHCP = true;
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Timezone
  time.timeZone = "Asia/Singapore";

  # Enable fstrim for SSD
  services.fstrim.enable = true;

  services.hardware.bolt.enable = true;

  virtualisation.incus.enable = true;
  networking.nftables.enable = true;
  networking.firewall.trustedInterfaces = [
    "incusbr0"
    "net_ovsbr0"
  ];
  virtualisation.vswitch.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
  ];
}
