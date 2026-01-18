let
  # Host SSH keys
  air = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIISR+/DYDRepHHCPKztgBsU56DNliMVdbh9pc6APKeT8";

  # User keys (optional - add your age key if you want to edit secrets without the host)
  # maari = "age1...";

  allHosts = [ air ];
in
{
  # VPN split tunnel networks for gpclient
  "gpclient-networks-air.age".publicKeys = [ air ];
}
