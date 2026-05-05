{
  flake.modules.nixos.incus =
    { config, lib, ... }:
    let
      cfg = config.nixma.nixos.incus;
    in
    {
      options.nixma.nixos.incus.enable = lib.mkEnableOption "Incus container/VM runtime with vswitch";

      config = lib.mkIf cfg.enable {
        virtualisation.incus.enable = true;
        networking.nftables.enable = true;
        networking.firewall.trustedInterfaces = [
          "incusbr0"
          "net_ovsbr0"
        ];
        virtualisation.vswitch.enable = true;
      };
    };
}
