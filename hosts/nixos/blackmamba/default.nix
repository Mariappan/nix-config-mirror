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
    ../../../modules/nixos/hyprland.nix
    ../../../modules/nixos/sound.nix
    ../../../modules/nixos/headless.nix
    ../../../modules/nixos/docker.nix
    ../../../modules/nixos/1password.nix
    ../../../modules/nixos/virtualbox.nix
  ];

  # Set the primary user for this system
  nixma.primaryUser = "maari";

  # System configs
  networking.hostName = "blackmamba";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Timezone
  time.timeZone = "Asia/Singapore";

  # Enable fstrim for SSD
  services.fstrim.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHmCMRUlvFEr8DTgChajPHJA069XKU+RECk/hurkIo2h"
  ];
}
