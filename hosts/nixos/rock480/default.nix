{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
  ];

  # Set the primary user for this system
  nixma.nixos.params.primaryUser = "maari";

  # Configure users
  nixma.nixos.users.root.enable = true;
  nixma.nixos.users.maari = {
    enable = true;
    email = "2441529-Mariappan@users.noreply.gitlab.com";
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/gQaDONy7ryuW8R7tsnUxxpEoqQ1erZuM4KOb3VLAc maari@tetra"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB3JnJ0u7pwetXhzAmskHUmxfQjcCtoyModO+IRKL89 homelab@1password"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P xv@1password"
    ];
    bundle = "rock480";
    gitSignByDefault = false;
  };

  # Hardware configuration
  nixma.nixos.hardware = {
    cpu.vendor = "intel";
  };

  # Boot configuration
  nixma.nixos.boot = {
    kernelPackage = "latest";
    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
  };

  # Enable nixos features
  nixma.nixos = {
    "1password".enable = true;
    bluetooth.enable = true;
    docker.enable = true;
    fprint.enable = true;
    hidraw.enable = true;
    laptop.enable = true;
    manpages.enable = true;
    niri.enable = true;
    nvidia.enable = true;
    plymouth.enable = true;
    screenrecorder.enable = true;
    sound.enable = true;
    zen-browser.enable = true;
  };

  # System configs
  networking.hostName = "rock480";

  # Timezone
  time.timeZone = "Asia/Singapore";

  programs.mosh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.fwupd.enable = true;
}
