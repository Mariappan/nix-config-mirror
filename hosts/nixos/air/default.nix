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
    ../shared/hyprland.nix
    ../shared/laptop.nix
    ../shared/sound.nix
    ../shared/docker.nix
    ../shared/1password.nix
    ../shared/virtualbox.nix
    ../shared/nvidia.nix
  ];

  programs.yubikey-touch-detector.enable = true;

  # System configs
  networking.hostName = "air";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  networking.networkmanager = {
    dispatcherScripts = [ {
        source = pkgs.writeText "wired-wifi-toggle" ''
          #!/usr/bin/env ${pkgs.bash}/bin/bash

          # Redirect script output to the system log for easy debugging.
          exec 1> >(${pkgs.util-linux}/bin/logger -t nm-dispatcher-wired-wifi) 2>&1

          INTERFACE="$1"
          ACTION="$2"

          # Check if the event is for an Ethernet connection
          # if [[ "$(${pkgs.networkmanager}/bin/nmcli -g GENERAL.TYPE device show "$INTERFACE")" == "ethernet" ]]; then

          if [[  "$INTERFACE" == "enp0s13f0u4u4u2" ]]; then
            echo "Ethernet event detected on interface $INTERFACE with action $ACTION."

            case "$ACTION" in
              "up")
                echo "Ethernet connection is up. Disabling Wi-Fi..."
                ${pkgs.networkmanager}/bin/nmcli radio wifi off
                ;;
              "down")
                echo "Ethernet connection is down. Enabling Wi-Fi..."
                ${pkgs.networkmanager}/bin/nmcli radio wifi on
                ;;
            esac
          fi
        '';
        type = "basic";
      }
    ];
  };

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
