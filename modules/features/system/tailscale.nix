# Tailscale
{
  flake.modules.nixos.tailscale =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.nixma.nixos.tailscale;
    in
    {
      options.nixma.nixos.tailscale = {
        tailscale = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable the Tailscale mesh-VPN daemon.";
        };
      };

      config = {
        nixma.nixos.imported.tailscale = true;

        services.tailscale.enable = true;
        networking.firewall = {
          trustedInterfaces = [ config.services.tailscale.interfaceName ];
          allowedUDPPorts = [ config.services.tailscale.port ];
        };
        systemd.services.tailscaled.serviceConfig.Environment = [
          "TS_DEBUG_FIREWALL_MODE=nftables"
        ];
      };
    };
}
