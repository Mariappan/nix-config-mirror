{ config, lib, ... }:
{
  nixma.nixos."1password".allowedBrowsers = lib.mkIf config.nixma.nixos."1password".enable [
    "vivaldi-bin"
  ];
}
