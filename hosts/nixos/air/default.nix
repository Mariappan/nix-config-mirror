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
    ../shared/hyprland.nix
    ../shared/sound.nix
    ../shared/docker.nix
    ../shared/1password.nix
    ../shared/virtualbox.nix
    ../shared/nvidia.nix
  ];

  # System configs
  networking.hostName = "air";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Timezone
  time.timeZone = "Asia/Singapore";

  # Enable fstrim for SSD
  services.fstrim.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P"
  ];

  # To avoid HHKB sending Power key on ignoring "Fn+Esc"
  services.logind.powerKey = "ignore";

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
