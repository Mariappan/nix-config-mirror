{
  flake.modules.nixos.nix-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      isSbc = config.nixma.nixos.formFactor == "sbc";
      # Workstation helpers (nh, nix-alien, nix-ld) only make sense on
      # interactive hosts. Skip on SBC / headless servers to keep the
      # closure lean and avoid cross-compiling things like nix-ld on
      # armv7l where upstream doesn't build.
      enableWorkstationTools = !isSbc;
    in
    {
      nixma.nixos.imported.nix-settings = true;

      # Necessary for using flakes on this system
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Disable default nix registry on SBC hosts.
      # Use: nix shell github:NixOS/nixpkgs#htop
      nix.registry = lib.mkIf isSbc (lib.mkForce { });
      nix.channel.enable = lib.mkIf isSbc false;

      # Automatic store optimization
      nix.optimise.automatic = true;
      nix.optimise.dates = [ "03:45" ];

      # Workstation-only tooling:
      #   nix-ld     — let foreign binaries find their dynamic linker
      #   nh         — nix helper, drives system + cleanup
      #   nix-alien  — run upstream binaries against patchelf'd libs
      programs.nix-ld.enable = enableWorkstationTools;
      programs.nh = lib.mkIf enableWorkstationTools {
        enable = true;
        clean.enable = true;
        # Keep 30 days of generations / store paths so cross-compiled SBC
        # closures (e.g. chip) aren't GC'd between builds. Bump higher per
        # host if you cross-compile for multiple SBCs and want all retained.
        clean.extraArgs = "--keep-since 30d --keep 10";
        flake = "/home/maari/nix-config";
      };
      environment.systemPackages = lib.optional enableWorkstationTools pkgs.nix-alien;
    };
}
