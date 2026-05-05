# Run test target as default
default: test

# Update flake input
update flake='':
    nix flake update {{flake}}

# Activate the new config. Dont update the bootloader
[linux]
test flake='.':
    nh os test {{flake}} -- --accept-flake-config

# Build and see the diff
[linux]
verify flake='.':
    nh os switch -n {{flake}} -- --accept-flake-config

# Build nixos and activate and update bootloader
[linux]
build flake='.':
    sudo nixos-rebuild switch --flake {{flake}}

# Activate the new config. Dont update the bootloader
[macos]
test flake='.':
    sudo darwin-rebuild activate --flake {{flake}} --option accept-flake-config true

# Build nix-darwin
[macos]
build flake='.':
    sudo darwin-rebuild switch --flake {{flake}} --option accept-flake-config true

# Evaluate config Ex: just eval-air hardware.graphics
[linux]
eval-air param:
    nix eval .#nixosConfigurations.air.config.{{param}} --json | jq .

# Show every nixma.nixos.<x>.enable for a host. Ex: just enabled rock3c
[linux]
enabled host:
    @nix eval --json .#nixosConfigurations.{{host}}.config.nixma.nixos \
      --apply 'cfg: builtins.mapAttrs (_: v: if builtins.isAttrs v && v ? enable then v.enable else null) cfg' \
      | jq -r 'to_entries | map(select(.value != null)) | sort_by(.key) | .[] | "  \(.key) = \(.value)"'

# Build on indiarpi (aarch64 native), deploy to rock3c over SSH.
# Use `just deploy-rock3c -vv` to forward extra flags through to nh.
[linux]
deploy-rock3c *args='':
    nh os switch . -H rock3c \
      --target-host maari@hl-rock3c \
      --build-host maari@indiarpi \
      {{args}}

# List available Linux kernels
lskernels:
    @nix eval --raw nixpkgs#linuxKernel.packages --apply 'x: builtins.concatStringsSep "\n" (builtins.attrNames x)' 2>/dev/null | grep -v recurse

