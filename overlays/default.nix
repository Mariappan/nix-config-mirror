# Overlays
# Ref: https://github.com/Misterio77/nix-config/blob/main/overlays/default.nix
{ inputs, ... }:
{
  # This one brings our custom packages from the 'packages' directory
  additions = final: prev: {
    nixma = import ../packages { pkgs = final; };

    hyprlockfix = prev.pkgs.writeShellScriptBin "hyprlockfix" ''
      hyprctl --instance 0 "keyword misc:allow_session_lock_restore 1"
      hyprctl --instance 0 "dispatch exec hyprlock"
    '';
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: prev: {
  };

  unused = _final: prev: {
    # Wayland deps for virtualbox GUI on no-X11 systems.
    # Mirrors https://github.com/NixOS/nixpkgs/pull/492016
    virtualbox = prev.virtualbox.overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ prev.qt6.qtwayland ];
      preFixup =
        ''
          for bin in $out/bin/VirtualBox $out/libexec/virtualbox/VirtualBoxVM; do
            [ -e "$bin" ] || continue
            patchelf "$bin" \
              --add-needed libwayland-client.so.0 \
              --add-rpath ${prev.lib.makeLibraryPath [ prev.wayland ]}
          done
        ''
        + (old.preFixup or "");
    });
    claude-code =
      builtins.trace "WARNING: claude-code is pinned to 2.1.116 via overlay. Remove this override"
        (
          prev.claude-code.overrideAttrs (oldAttrs: rec {
            version = "2.1.116";
            src = prev.fetchurl {
              url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${version}/${prev.stdenv.hostPlatform.parsed.kernel.name}-${
                if prev.stdenv.hostPlatform.isx86_64 then "x64" else "arm64"
              }/claude";
              hash = "sha256-DRrqXOBWpc5JHafpu+Y/mSWF5cJIUvAjoHyPGM8pLMU=";
            };
          })
        );
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

  # Pinned channel package sets, accessible through 'pkgs._stable' (26.05)
  # and 'pkgs._oldstable' (25.11).
  stable-packages = final: _prev: {
    _stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
    _oldstable = import inputs.nixpkgs-oldstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  # nix-alien only ships packages for x86_64-linux + aarch64-linux + darwin
  # variants. Skip the overlay on systems it doesn't support (e.g. armv7l-linux
  # for the CHIP host) so eval doesn't fall over on the missing attribute.
  default = final: prev:
    let
      supported = builtins.hasAttr prev.stdenv.hostPlatform.system inputs.nix-alien.packages;
    in
    if supported then inputs.nix-alien.overlays.default final prev else { };
}
