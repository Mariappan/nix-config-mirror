{ ... }:
{
  virtualisation.incus.enable = true;
  networking.nftables.enable = true;
  networking.firewall.trustedInterfaces = [
    "incusbr0"
    "net_ovsbr0"
  ];
  virtualisation.vswitch.enable = true;
}
