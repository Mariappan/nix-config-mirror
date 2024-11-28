# Overlays
# Ref: https://github.com/Misterio77/nix-config/blob/main/overlays/default.nix
{inputs, ...}: {
  # This one brings our custom packages from the 'packages' directory
  additions = final: _prev: {
    nixma = import ../packages {pkgs = final;};
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: prev: {
    wezterm = inputs.wezterm.packages.${prev.stdenv.hostPlatform.system}.default;
  };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  default = inputs.nixpkgs.lib.composeManyExtensions [
    inputs.nix-alien.overlays.default
    inputs.nixpkgs-wayland.overlay
  ];
}
