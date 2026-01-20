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
    resolved = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable systemd-resolved for DNS resolution.

          systemd-resolved provides:
          - DNS caching
          - DNSSEC validation
          - DNS-over-TLS support
          - Per-interface DNS routing (split DNS)
          - mDNS support

          When disabled, resolvconf is used instead (simpler, no caching).
        '';
      };

      dnssec = lib.mkOption {
        type = lib.types.enum [ "true" "false" "allow-downgrade" ];
        default = "allow-downgrade";
        description = ''
          DNSSEC validation mode:
          - "true": Strict DNSSEC validation
          - "false": Disable DNSSEC
          - "allow-downgrade": Use DNSSEC when available, fall back when not
        '';
      };

      dnsovertls = lib.mkOption {
        type = lib.types.enum [ "true" "false" "opportunistic" ];
        default = "false";
        description = ''
          DNS-over-TLS mode:
          - "true": Require TLS for all DNS queries
          - "false": Disable DNS-over-TLS
          - "opportunistic": Use TLS when available
        '';
      };

      fallbackDns = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "1.1.1.1" "8.8.8.8" ];
        description = "Fallback DNS servers when no other DNS servers are available.";
      };
    };
  };

  config = {
    # NetworkManager handles network connections
    networking.networkmanager.enable = true;
    # NetworkManager handles DHCP, so useDHCP is not needed
    # networking.useDHCP = true;

    # Enable mDNS for NetworkManager connections (used by systemd-resolved)
    networking.networkmanager.connectionConfig."connection.mdns" = 2;

    # NetworkManager dispatcher script to disable WiFi when wired connection is active
    networking.networkmanager.dispatcherScripts = [
      {
        source = "${pkgs.nixma.wired_wifi_toggle}/bin/wired_wifi_toggle";
        type = "basic";
      }
    ];

    # Enable firewall
    networking.firewall.enable = true;

    # NTP configuration
    networking.timeServers = [
      "0.sg.pool.ntp.org"
      "1.sg.pool.ntp.org"
      "2.sg.pool.ntp.org"
      "3.sg.pool.ntp.org"
    ];
    services.ntp.enable = true;

    # DNS resolution (using new settings interface from nixpkgs)
    # mDNS resolution handled by systemd-resolved; Avahi handles service discovery/publishing
    services.resolved = lib.mkIf cfg.resolved.enable {
      enable = true;
      settings.Resolve = {
        DNSSEC = cfg.resolved.dnssec;
        DNSOverTLS = cfg.resolved.dnsovertls;
        MulticastDNS = "true";
      } // lib.optionalAttrs (cfg.resolved.fallbackDns != [ ]) {
        FallbackDNS = cfg.resolved.fallbackDns;
      };
    };

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
    ];

    # Enable Mosh daemon (UDP SSH)
    programs.mosh.enable = true;

    # Avahi for service discovery/publishing only (mDNS resolution via systemd-resolved)
    services.avahi = {
      enable = true;
      nssmdns4 = false;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };
  };
}
