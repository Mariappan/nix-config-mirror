{
  flake.modules.nixos.nautilus =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.nixma.nixos.nautilus;
    in
    {
      options.nixma.nixos.nautilus.enable =
        lib.mkEnableOption "Nautilus file manager with GVFS, Samba and NFS support";

      config = lib.mkIf cfg.enable {
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
    };
}
