# Overlays
# Ref: https://github.com/Misterio77/nix-config/blob/main/overlays/default.nix
{ inputs, ... }:
{
  # This one brings our custom packages from the 'packages' directory
  additions = final: prev: {
    nixma = import ../packages { pkgs = final; };
    caelestia-shell = inputs.caelestia-shell.packages.${prev.system}.default;
    caelestia-cli = inputs.caelestia-cli.packages.${prev.system}.default;
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: prev: {
    caelestia-shell = prev.caelestia-shell.overrideAttrs (
      finalAttrs: prevAttrs: {
        withCli = true;
      }
    );
    vivaldi-wayland =
      prev.vivaldi.override {
        commandLineArgs = ''
          --enable-features=UseOzonePlatform
          --ozone-platform=wayland
          --ozone-platform-hint=auto
          --enable-features=WaylandWindowDecorations
        '';
      };
  };

  unused = _final: prev: {
    hyprlandPlugins.hy3 = prev.hyprlandPlugins.hy3.overrideAttrs (
      finalAttrs: prevAttrs: {
        patches = [ ./hy3_fix.patch ];
      }
    );
    wayprompt = prev.wayprompt.overrideAttrs (oldAttrs: {
      version = "66fe87408d3cfba8c8cc6ff65c1868e5db6ad3bb";
      src = prev.fetchFromSourcehut {
        owner = "~leon_plickat";
        repo = "wayprompt";
        rev = "66fe87408d3cfba8c8cc6ff65c1868e5db6ad3bb";
        sha256 = "sha256-Oz98oo3auhbBu9tl5pENoyJ9cMexcwPuRk18H4mLkjg=";
        fetchSubmodules = true;
      };
    });
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
    # inputs.nixpkgs-wayland.overlay
  ];
}
