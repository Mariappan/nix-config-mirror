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
    dispatcherScripts = [
      {
        source = pkgs.writeText "wired-wifi-toggle" ''
          #!/usr/bin/env ${pkgs.bash}/bin/bash

          # Redirect script output to the system log for easy debugging.
          exec 1> >(${pkgs.util-linux}/bin/logger -t nm-dispatcher-wired-wifi) 2>&1

          INTERFACE="$1"
          ACTION="$2"

          # Check if the event is for an Ethernet connection
          DEVICE_TYPE=$(${pkgs.networkmanager}/bin/nmcli -g GENERAL.TYPE device show "$INTERFACE" 2>/dev/null || echo "unknown")
          
          # Handle ethernet devices or when device type is unknown (removed USB ethernet)
          if [[ "$DEVICE_TYPE" == "ethernet" ]] || [[ "$DEVICE_TYPE" == "unknown" && "$ACTION" == "down" ]]; then
            if [[ "$DEVICE_TYPE" == "ethernet" ]]; then
              echo "Ethernet event detected on interface $INTERFACE with action $ACTION."
            else
              echo "Device $INTERFACE removed (likely USB ethernet). Action: $ACTION."
            fi

            case "$ACTION" in
              "up")
                echo "Ethernet connection is up. Waiting for network configuration..."

                # Wait for default route to be established (up to 15 seconds)
                for i in {1..15}; do
                  if ${pkgs.iproute2}/bin/ip route | ${pkgs.gnugrep}/bin/grep -q "default.*dev $INTERFACE"; then
                    echo "Default route established after $i seconds."
                    break
                  fi
                  sleep 1
                done

                # Check if we have a default route via this ethernet interface
                if ${pkgs.iproute2}/bin/ip route | ${pkgs.gnugrep}/bin/grep -q "default.*dev $INTERFACE"; then
                  # Test gateway connectivity
                  GATEWAY=$(${pkgs.iproute2}/bin/ip route | ${pkgs.gnugrep}/bin/grep "default.*dev $INTERFACE" | ${pkgs.gawk}/bin/awk '{print $3}' | head -1)

                  if [[ -n "$GATEWAY" ]] && ${pkgs.iputils}/bin/ping -c 2 -W 3 "$GATEWAY" >/dev/null 2>&1; then
                    echo "Gateway $GATEWAY is reachable via ethernet. Disabling Wi-Fi..."
                    ${pkgs.networkmanager}/bin/nmcli radio wifi off
                  else
                    echo "Gateway not reachable via ethernet. Keeping Wi-Fi enabled."
                  fi
                else
                  echo "No default route via ethernet interface after 15 seconds. Keeping Wi-Fi enabled."
                fi
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
  services.logind.settings.Login.HandlePowerKey = "ignore";

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
