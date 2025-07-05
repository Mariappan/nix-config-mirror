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
    ../shared/hyprland.nix
    ../shared/sound.nix
    ../shared/headless.nix
    ../shared/docker.nix
    ../shared/1password.nix
    ../shared/virtualbox.nix
  ];

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
