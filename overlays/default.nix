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
    claude-code-bin = builtins.trace "WARNING: claude-code-bin is pinned to 2.1.116 via overlay. Remove this override" (
      prev.claude-code-bin.overrideAttrs (oldAttrs: rec {
        version = "2.1.116";
        src = prev.fetchurl {
          url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${version}/${prev.stdenv.hostPlatform.parsed.kernel.name}-${
            if prev.stdenv.hostPlatform.isx86_64 then "x64" else "arm64"
          }/claude";
          hash = "sha256-DRrqXOBWpc5JHafpu+Y/mSWF5cJIUvAjoHyPGM8pLMU=";
        };
      })
    );
  };

  unused = _final: prev: {
    hyprlandPlugins.hy3 = prev.hyprlandPlugins.hy3.overrideAttrs (
      finalAttrs: prevAttrs: {
        patches = [ ./hy3_fix.patch ];
      }
    );
    vivaldi-wayland = prev.vivaldi.override {
      commandLineArgs = ''
        --enable-features=UseOzonePlatform
        --ozone-platform=wayland
        --ozone-platform-hint=auto
        --enable-features=WaylandWindowDecorations
      '';
    };

    slack = prev.slack.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        substituteInPlace $out/share/applications/slack.desktop \
          --replace-fail 'bin/slack -s' 'bin/slack --ozone-platform=wayland -s'
      '';
    });
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
  # be accessible through 'pkgs._2511'
  stable-packages = final: _prev: {
    _2511 = import inputs.nixpkgs-2511 {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
    _2505 = import inputs.nixpkgs-2505 {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  default = inputs.nixpkgs.lib.composeManyExtensions [
    inputs.nix-alien.overlays.default
    inputs.niri.overlays.niri
  ];
}
