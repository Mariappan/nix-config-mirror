{
  flake.modules.nixos.virtualbox =
    { config, lib, ... }:
    let
      cfg = config.nixma.nixos.virtualbox;
    in
    {
      options.nixma.nixos.virtualbox.enable =
        lib.mkEnableOption "VirtualBox host daemon and bridged network defaults";

      config = lib.mkIf cfg.enable {
        virtualisation.virtualbox.host.enable = true;
        # virtualisation.virtualbox.host.enableExtensionPack = true;
        # virtualisation.virtualbox.guest.enable = true;
        # virtualisation.virtualbox.guest.x11 = true;

        environment.etc."vbox/networks.conf".text = ''
          * 192.168.220.0/24
          * 2001:db8:beef::/48
        '';
      };
    };
}
