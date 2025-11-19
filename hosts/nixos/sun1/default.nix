{
  lib,
  pkgs,
  home-manager,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./users.nix
    ../../../modules/nixos/common.nix
    ../../../modules/nixos/manpages.nix
    ../../../modules/nixos/lanzaboote.nix
    ../../../modules/nixos/headless.nix
    ../../../modules/nixos/niri.nix
    ../../../modules/nixos/sound.nix
    ../../../modules/nixos/docker.nix
    ../../../modules/nixos/1password.nix
    ../../../modules/nixos/virtualbox.nix
    ../../../modules/nixos/screenrecorder.nix
  ];

  # Set the primary user for this system
  nixma.primaryUser = "maari";

  # System configs
  networking.hostName = "sun1";
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
