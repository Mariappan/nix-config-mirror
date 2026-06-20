{
  flake.modules.nixos.docker =
    { pkgs, ... }:
    {
      nixma.nixos.imported.docker = true;

      virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
        extraPackages = with pkgs; [nftables];
        extraOptions = "--firewall-backend=nftables";
      };
      virtualisation.docker.daemon.settings = {
        bip = "10.163.1.1/24";
        default-address-pools = [
          {
            base = "10.163.2.0/18";
            size = 24;
          }
        ];
      };
    };
}
