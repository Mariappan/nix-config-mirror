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
  };
}
