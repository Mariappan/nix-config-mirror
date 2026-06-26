{
  flake.modules.nixos.incus =
    { ... }:
    {
      nixma.nixos.imported.incus = true;

      virtualisation.incus.enable = true;
      networking.nftables.enable = true;
      networking.firewall.trustedInterfaces = [
        "incusbr0"
        # Lab bridges (hyphenated names, as Incus creates them). net-uplink
        # carries isp-edge's WAN DHCP + NAT to the real internet, so the host
        # firewall must trust it or instances get no lease / no internet.
        "net-ovsbr0"
        "net-uplink"
      ];
      virtualisation.vswitch.enable = true;
    };
}
