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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/gQaDONy7ryuW8R7tsnUxxpEoqQ1erZuM4KOb3VLAc maari@tetra"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB3JnJ0u7pwetXhzAmskHUmxfQjcCtoyModO+IRKL89 homelab@1password"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P xv@1password"
    ];
    extraGroups = [ "incus-admin" ]; # Added to default groups
    bundle = "dull5080";
    gitSignByDefault = false;
  };

  # Hardware configuration
  nixma.nixos.hardware = {
    cpu.vendor = "intel";
  };

  # Boot configuration
  nixma.nixos.boot = {
    kernelModules = [ "kvm-intel" ];
    initrd.availableKernelModules = [
      "ahci"
      "nvme"
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
  };

  # Enable nixos features
  nixma.nixos = {
    docker.enable = true;
    headless.enable = true;
  };

  # System configs
  networking.hostName = "dull5080";

  # Host-specific networking configuration
  time.timeZone = "Asia/Singapore";
}
