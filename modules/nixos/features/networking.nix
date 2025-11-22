{ pkgs, ... }:
{
  # NetworkManager handles network connections
  networking.networkmanager.enable = true;
  # NetworkManager handles DHCP, so useDHCP is not needed
  # networking.useDHCP = true;

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

  # Avahi (mDNS/Bonjour) configuration for service discovery
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;
}
