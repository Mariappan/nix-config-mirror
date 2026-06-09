# Backend-agnostic host network services: OpenSSH, Mosh, NTP, systemd-resolved, Avahi.
{
  flake.modules.nixos.network-services =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.nixma.nixos.networkServices;
    in
    {
      options.nixma.nixos.networkServices = {
        rootKeys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P 1password@xvpn"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3bwlIYLqj7YgfDNhFoAWgP5hg9+TOXmhnRZM9R8Bfi"
          ];
          description = "SSH authorized keys installed for the root user.";
        };

        ntpServers = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "0.sg.pool.ntp.org"
            "1.sg.pool.ntp.org"
            "2.sg.pool.ntp.org"
            "3.sg.pool.ntp.org"
          ];
          description = "NTP time servers.";
        };

        mosh = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable the Mosh (UDP SSH) daemon.";
        };

        tailscale = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable the Tailscale mesh-VPN daemon.";
        };

        avahiPublish = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Publish records over Avahi/mDNS (host addresses; per-host service files,
            e.g. SMB/_device-info, are added by the consuming module).
          '';
        };

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
            type = lib.types.enum [
              "true"
              "false"
              "allow-downgrade"
            ];
            default = "allow-downgrade";
            description = ''
              DNSSEC validation mode:
              - "true": Strict DNSSEC validation
              - "false": Disable DNSSEC
              - "allow-downgrade": Use DNSSEC when available, fall back when not
            '';
          };

          dnsovertls = lib.mkOption {
            type = lib.types.enum [
              "true"
              "false"
              "opportunistic"
            ];
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
            example = [
              "1.1.1.1"
              "8.8.8.8"
            ];
            description = "Fallback DNS servers when no other DNS servers are available.";
          };
        };
      };

      config = {
        nixma.nixos.imported.network-services = true;

        services.openssh.enable = true;
        users.users.root.openssh.authorizedKeys.keys = cfg.rootKeys;

        programs.mosh.enable = cfg.mosh;
        services.tailscale.enable = cfg.tailscale;

        networking.timeServers = cfg.ntpServers;
        services.ntp.enable = true;

        # resolved does mDNS resolution; avahi does the publishing.
        services.resolved = lib.mkIf cfg.resolved.enable {
          enable = true;
          settings.Resolve = {
            DNSSEC = cfg.resolved.dnssec;
            DNSOverTLS = cfg.resolved.dnsovertls;
            MulticastDNS = "true";
          }
          // lib.optionalAttrs (cfg.resolved.fallbackDns != [ ]) {
            FallbackDNS = cfg.resolved.fallbackDns;
          };
        };

        services.avahi = {
          enable = true;
          nssmdns4 = false;
          openFirewall = true;
          publish = {
            enable = cfg.avahiPublish;
            addresses = cfg.avahiPublish;
          };
        };
      };
    };
}
