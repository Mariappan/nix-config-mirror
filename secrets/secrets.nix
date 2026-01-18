let
  # Host SSH keys
  air = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIISR+/DYDRepHHCPKztgBsU56DNliMVdbh9pc6APKeT8";

  # User keys
  homelab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB3JnJ0u7pwetXhzAmskHUmxfQjcCtoyModO+IRKL89";
  xv-maari = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P";

  allKeys = [ air homelab xv-maari ];
in
{
  # VPN split tunnel configs for gpclient
  "gpclient-networks-air.age".publicKeys = allKeys;
  "gpclient-domains-air.age".publicKeys = allKeys;
}
