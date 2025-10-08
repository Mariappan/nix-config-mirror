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
    ../shared/common.nix
    ../shared/manpages.nix
    ../shared/lanzaboote.nix
    ../shared/headless.nix
    ../shared/niri.nix
    ../shared/sound.nix
    ../shared/docker.nix
    ../shared/1password.nix
    ../shared/virtualbox.nix
    ../shared/screenrecorder.nix
  ];

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
