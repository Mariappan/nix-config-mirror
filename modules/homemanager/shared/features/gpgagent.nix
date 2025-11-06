{ pkgs, ... }:
{
  home.packages = [
    pkgs.gnupg
  ];

  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    enableSshSupport = true;
    extraConfig = "pinentry-program ${pkgs.wayprompt}/bin/pinentry-wayprompt";
    defaultCacheTtl = 3600;
    defaultCacheTtlSsh = 3600;
    maxCacheTtl = 14400;
    maxCacheTtlSsh = 14400;
  };
}
