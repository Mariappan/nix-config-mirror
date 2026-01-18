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

        # Read networks from secret file if it exists
        NETWORKS_FILE="${cfg.splitTunnelNetworksFile}"
        if [[ -n "$NETWORKS_FILE" && -r "$NETWORKS_FILE" ]]; then
          log "Reading networks from $NETWORKS_FILE"
          while IFS= read -r network || [[ -n "$network" ]]; do
            # Skip empty lines and comments
            [[ -z "$network" || "$network" == \#* ]] && continue

            if ! ${pkgs.iproute2}/bin/ip route show "$network" dev "$INTERFACE" 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q .; then
              log "Adding route for $network through VPN"
              if [[ -n "$VPN_GW" ]]; then
                ${pkgs.iproute2}/bin/ip route add "$network" via "$VPN_GW" dev "$INTERFACE" 2>/dev/null || \
                ${pkgs.iproute2}/bin/ip route add "$network" dev "$INTERFACE" 2>/dev/null || true
              else
                ${pkgs.iproute2}/bin/ip route add "$network" dev "$INTERFACE" 2>/dev/null || true
              fi
            fi
          done < "$NETWORKS_FILE"
        else
          log "Networks file not found or not readable: $NETWORKS_FILE"
        fi

        # Resolve domains and add routes for their IPs
        DOMAINS_FILE="${cfg.splitTunnelDomainsFile}"
        if [[ -n "$DOMAINS_FILE" && -r "$DOMAINS_FILE" ]]; then
          log "Reading domains from $DOMAINS_FILE"
          while IFS= read -r domain || [[ -n "$domain" ]]; do
            # Skip empty lines and comments
            [[ -z "$domain" || "$domain" == \#* ]] && continue

            log "Resolving $domain"
            for ip in $(${pkgs.dig}/bin/dig +short "$domain" 2>/dev/null | ${pkgs.gnugrep}/bin/grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'); do
              if ! ${pkgs.iproute2}/bin/ip route show "$ip/32" dev "$INTERFACE" 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q .; then
                log "Adding route for $ip ($domain) through VPN"
                if [[ -n "$VPN_GW" ]]; then
                  ${pkgs.iproute2}/bin/ip route add "$ip/32" via "$VPN_GW" dev "$INTERFACE" 2>/dev/null || \
                  ${pkgs.iproute2}/bin/ip route add "$ip/32" dev "$INTERFACE" 2>/dev/null || true
                else
                  ${pkgs.iproute2}/bin/ip route add "$ip/32" dev "$INTERFACE" 2>/dev/null || true
                fi
              fi
            done
          done < "$DOMAINS_FILE"
        fi

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

    splitTunnelNetworksFile = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "/run/agenix/gpclient-networks";
      description = ''
        Path to a file containing networks (one per line) to route through VPN.
        Use this with agenix to keep IPs private.
      '';
    };

    splitTunnelDomainsFile = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "/run/agenix/gpclient-domains";
      description = ''
        Path to a file containing domains (one per line) to resolve and route through VPN.
        IPs are resolved dynamically when VPN connects.
      '';
    };
  };

  config = lib.mkIf (cfg.splitTunnelNetworksFile != "" || cfg.splitTunnelDomainsFile != "") {
    # NetworkManager dispatcher script for split tunneling
    networking.networkmanager.dispatcherScripts = [
      {
        source = gpSplitTunnelScript;
        type = "basic";
      }
    ];
  };
}
