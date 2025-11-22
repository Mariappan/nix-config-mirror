{ ... }:
{
  # Necessary for using flakes on this system
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
}
