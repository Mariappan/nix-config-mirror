{pkgs, ...}: {
  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    enableSshSupport = true;
    extraConfig = "pinentry-program ${pkgs.stable.wayprompt}/bin/pinentry-wayprompt";
  };
}
