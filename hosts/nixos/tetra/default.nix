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
    bundle = "tetra";
    gitSignByDefault = false;
  };

  # Hardware configuration
  nixma.nixos.hardware = {
    work.enable = false;
    swap.enable = true;
    cpu.vendor = "intel";
  };

  # Boot configuration
  nixma.nixos.boot = {
    kernelModules = [ "kvm-intel" ];
    kernelPackage = "latest";
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "thunderbolt"
      "ahci"
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
    # lanzaboote.enable = true;
    manpages.enable = true;
    niri.enable = true;
    screenrecorder.enable = true;
    sound.enable = true;
    nvidia.enable = true;
    virtualbox.enable = true;
  };

  # System configs
  networking.hostName = "tetra";

  programs.mosh.enable = true;

  # Host-specific networking configuration
  time.timeZone = "Asia/Singapore";
}
