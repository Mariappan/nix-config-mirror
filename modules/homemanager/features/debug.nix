{ pkgs, ... }:
{
  home.packages = [
    pkgs.tcpdump
    pkgs.dnsutils
    # Modern DNS util
    pkgs.q
    pkgs.nmap
    pkgs.socat
    # Tracking HEAP allocations in a modern way
    pkgs.heaptrack
    pkgs.termshark
    pkgs.binsider
    pkgs.whois
    pkgs.wireshark
  ];
}
