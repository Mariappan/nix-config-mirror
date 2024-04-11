{pkgs, ...}: {
  home.packages = [
    pkgs.tcpdump
    pkgs.socat
    pkgs.termshark
    pkgs.whois
  ];
}
