{pkgs, ...}: {
  services.gpg-agent = {
    enable = false;
    enableScDaemon = false;
    enableSshSupport = false;
    # extraConfig = "pinentry-program ${pkgs.wayprompt}/bin/pinentry-wayprompt";
  };
}
