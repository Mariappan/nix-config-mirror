{ pkgs, ... }:
{
  home.packages = [
    pkgs.gnupg
  ];

  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    enableSshSupport = true;
    extraConfig =
      let
        pinentryProgram =
          if pkgs.stdenv.isDarwin then
            "${pkgs.pinentry_mac}/bin/pinentry-mac"
          else
            "${pkgs.wayprompt}/bin/pinentry-wayprompt";
      in
      "pinentry-program ${pinentryProgram}";
    defaultCacheTtl = 3600;
    defaultCacheTtlSsh = 3600;
    maxCacheTtl = 14400;
    maxCacheTtlSsh = 14400;
  };
}
