let
  # Host SSH keys
  air = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIISR+/DYDRepHHCPKztgBsU56DNliMVdbh9pc6APKeT8 root@air";
  tetra = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBg8WtUgEzR5VqtytDZVGlhojYbAHbz7LX7w9CPk+th root@tetra";

  # User keys
  homelab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB3JnJ0u7pwetXhzAmskHUmxfQjcCtoyModO+IRKL89";
  xv-maari = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P";

  allKeys = [
    air
    tetra
    homelab
    xv-maari
  ];
in
{
  # Split network config
  "gpclient-networks-air.age".publicKeys = allKeys;
  "gpclient-domains-air.age".publicKeys = allKeys;
  # nix.conf `access-tokens = github.com=...` snippet for nix flake operations
  "nix-github-token.age".publicKeys = allKeys;
}
