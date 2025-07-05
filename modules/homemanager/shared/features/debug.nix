{pkgs, ...}: {
  home.packages = [
    pkgs.tcpdump
    pkgs.socat
    # Tracking HEAP allocations in a modern way
    pkgs.heaptrack
    pkgs.termshark
    pkgs.binsider
    pkgs.whois
    pkgs.wireshark
  ];
}
