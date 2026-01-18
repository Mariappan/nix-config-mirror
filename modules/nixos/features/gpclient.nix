{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixma.nixos.gpclient;

  # Script to configure split tunneling for GlobalProtect VPN
  gpSplitTunnelScript = pkgs.writeShellScript "gp-split-tunnel" ''
    # GlobalProtect VPN split tunnel configuration
    # Only route specified networks through VPN, keep default DNS

    INTERFACE="$1"
    ACTION="$2"

    # Only act on the GlobalProtect interface
    if [[ "$INTERFACE" != "${cfg.interface}" ]]; then
      exit 0
    fi

    log() {
      logger -t gp-split-tunnel "$@"
    }

    case "$ACTION" in
      up)
        log "VPN interface $INTERFACE is up, configuring split tunnel"

        # Wait a moment for routes to be set up
        sleep 1

        # Get the VPN gateway (first hop through the VPN interface)
        VPN_GW=$(${pkgs.iproute2}/bin/ip route show dev "$INTERFACE" | ${pkgs.gawk}/bin/awk '/default/ {print $3}')

        if [[ -z "$VPN_GW" ]]; then
          # If no default route, try to get any gateway
          VPN_GW=$(${pkgs.iproute2}/bin/ip route show dev "$INTERFACE" | ${pkgs.gnugrep}/bin/grep -oP 'via \K[0-9.]+' | head -1)
        fi

        log "VPN gateway: $VPN_GW"

        # Remove default route through VPN if it exists
        if ${pkgs.iproute2}/bin/ip route show default dev "$INTERFACE" 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q .; then
          log "Removing default route through VPN"
          ${pkgs.iproute2}/bin/ip route del default dev "$INTERFACE" 2>/dev/null || true
        fi

        # Remove Google DNS routes that gpclient adds
        for dns in 8.8.8.8 8.8.4.4; do
          if ${pkgs.iproute2}/bin/ip route show "$dns" dev "$INTERFACE" 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q .; then
            log "Removing DNS route $dns through VPN"
            ${pkgs.iproute2}/bin/ip route del "$dns" dev "$INTERFACE" 2>/dev/null || true
          fi
        done

        # Add specific routes for the networks that should go through VPN
        ${lib.concatMapStringsSep "\n" (network: ''
        if ! ${pkgs.iproute2}/bin/ip route show ${network} dev "$INTERFACE" 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q .; then
          log "Adding route for ${network} through VPN"
          if [[ -n "$VPN_GW" ]]; then
            ${pkgs.iproute2}/bin/ip route add ${network} via "$VPN_GW" dev "$INTERFACE" 2>/dev/null || \
            ${pkgs.iproute2}/bin/ip route add ${network} dev "$INTERFACE" 2>/dev/null || true
          else
            ${pkgs.iproute2}/bin/ip route add ${network} dev "$INTERFACE" 2>/dev/null || true
          fi
        fi
        '') cfg.splitTunnelNetworks}

        # Configure DNS: disable all name resolution on VPN interface
        log "Disabling DNS, LLMNR, and mDNS on VPN interface"
        ${pkgs.systemd}/bin/resolvectl dns "$INTERFACE" ""
        ${pkgs.systemd}/bin/resolvectl domain "$INTERFACE" ""
        ${pkgs.systemd}/bin/resolvectl default-route "$INTERFACE" false
        ${pkgs.systemd}/bin/resolvectl llmnr "$INTERFACE" no
        ${pkgs.systemd}/bin/resolvectl mdns "$INTERFACE" no

        log "Split tunnel configuration complete"
        ;;
      down)
        log "VPN interface $INTERFACE is down"
        ;;
    esac
  '';
in
{
  options.nixma.nixos.gpclient = {
    interface = lib.mkOption {
      type = lib.types.str;
      default = "tun0";
      description = ''
        The network interface name created by gpclient.
        Default is "tun0". Can be changed if you use gpclient's -i/--interface option.
      '';
    };

    splitTunnelNetworks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "10.4.0.0/16" "192.168.100.0/24" ];
      description = ''
        Networks that should be routed through the GlobalProtect VPN.
        All other traffic will use the default route (not through VPN).
      '';
    };
  };

  config = lib.mkIf (cfg.splitTunnelNetworks != [ ]) {
    # NetworkManager dispatcher script for split tunneling
    networking.networkmanager.dispatcherScripts = [
      {
        source = gpSplitTunnelScript;
        type = "basic";
      }
    ];
  };
}
