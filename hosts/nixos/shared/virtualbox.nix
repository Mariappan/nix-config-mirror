{ pkgs, ... }:
{
  virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # virtualisation.virtualbox.guest.enable = true;
  # virtualisation.virtualbox.guest.x11 = true;

  environment.etc."vbox/networks.conf".text = ''
    * 192.168.220.0/24
    * 2001:db8:beef::/48
  '';
}
