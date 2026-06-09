# Configurable networking backend + topology for NixOS systems.
{ self, ... }:
{
  flake.modules.nixos.networking =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.nixma.nixos.networking;
    in
    {
      options.nixma.nixos.networking = {
        strictArp = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable strict ARP behavior to prevent ARP flux issues when multiple
            interfaces are on the same subnet.

            When enabled, sets:
            - arp_ignore=1: Only respond to ARP if target IP is on receiving interface
            - arp_announce=2: Always use address from outgoing interface's subnet

            Problem: When WiFi and Ethernet connect to the same network, Linux's
            default "weak host model" responds to ARP for any local IP on any
            interface. The gateway may cache WiFi's MAC for Ethernet's IP, causing
            reply packets to arrive on the wrong interface (asymmetric routing).

            While Linux's weak host model would accept these packets, NixOS firewall
            has an iptables rpfilter in the mangle table that drops packets failing
            reverse path validation (packet arrived on WiFi but route back to source
            prefers Ethernet).

            This option prevents the issue at the source by ensuring each interface
            only responds to ARP requests for its own IP addresses.
          '';
        };

        wiredWifiToggle = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable NetworkManager dispatcher script to automatically disable WiFi
            when Ethernet is connected, and re-enable WiFi when Ethernet disconnects.

            This is an alternative approach to strictArp for handling dual-interface
            scenarios. With strictArp enabled (default), this is typically not needed.
          '';
        };

        backend = lib.mkOption {
          type = lib.types.enum [
            "networkmanager"
            "networkd"
          ];
          default = "networkmanager";
          description = ''
            Network management backend:
            - "networkmanager": full-featured stack with profile/modem support
              (default; suits laptops and workstations).
            - "networkd": lean systemd-networkd with a match-all DHCP ethernet
              profile (suits headless SBC servers; drops libqmi ~70 MiB).
          '';
        };
      };

      config = {
        nixma.nixos.imported.networking = true;

        # Strict ARP to prevent ARP flux with multiple interfaces on same subnet
        boot.kernel.sysctl = lib.mkIf cfg.strictArp {
          "net.ipv4.conf.all.arp_ignore" = 1;
          "net.ipv4.conf.all.arp_announce" = 2;
        };

        # NetworkManager backend
        networking.networkmanager = lib.mkIf (cfg.backend == "networkmanager") {
          enable = true;
          # mDNS for NM connections (used by systemd-resolved).
          connectionConfig."connection.mdns" = 2;
          # Dispatcher script to disable WiFi when wired link is up.
          dispatcherScripts = lib.mkIf cfg.wiredWifiToggle [
            {
              source = "${pkgs.nixma.wired_wifi_toggle}/bin/wired_wifi_toggle";
              type = "basic";
            }
          ];
        };

        # systemd-networkd backend
        networking.useNetworkd = cfg.backend == "networkd";
        networking.useDHCP = lib.mkDefault (cfg.backend == "networkd");
        systemd.network.networks."10-wired" = lib.mkIf (cfg.backend == "networkd") {
          matchConfig.Type = "ether";
          networkConfig.DHCP = "yes";
        };

        # Enable firewall
        networking.firewall.enable = true;
      };
    };
}
