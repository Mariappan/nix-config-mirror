{
  flake.modules.nixos.nix-settings = { config, lib, pkgs, ... }: {
    # Necessary for using flakes on this system
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Disable default nix registry in SBC hosts
    # Use: nix shell github:NixOS/nixpkgs#htop
    nix.registry = lib.mkIf (config.nixma.nixos.formFactor == "sbc") (lib.mkForce { });
    nix.channel.enable = lib.mkIf (config.nixma.nixos.formFactor == "sbc") false;

    # Automatic store optimization
    nix.optimise.automatic = true;
    nix.optimise.dates = [ "03:45" ];
    # Following optimize on every build but may result in slow build time
    # nix.settings.auto-optimise-store = true;

    # For running native binaries without patchelf
    programs.nix-ld.enable = true;

    # Nix helper tool for system management
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/maari/nix-config";
    };

    environment.systemPackages = [
      pkgs.nix-alien
    ];
  };
}
