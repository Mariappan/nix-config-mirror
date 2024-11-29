{pkgs, ...}: {
  home.packages = [
    pkgs.tcpdump
    pkgs.socat
    pkgs.termshark
    pkgs.binsider
    pkgs.whois
    pkgs.wireshark
  ];
}
