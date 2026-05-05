{
  flake.modules.nixos.nautilus =
    { pkgs, ... }:
    {
      # GVFS enables virtual filesystem support in nautilus (network drives, trash, etc.)
      services.gvfs.enable = true;

      environment.systemPackages = [
        pkgs.nautilus
        pkgs.samba # SMB/CIFS network share support
      ];

      # NFS support
      boot.supportedFilesystems = [ "nfs" ];
      services.rpcbind.enable = true;
    };
}
