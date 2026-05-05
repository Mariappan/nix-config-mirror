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

# List all NixOS and darwin hosts with their formFactor and roles.
hosts:
    @nix eval --json --impure --expr ' \
      let \
        f = builtins.getFlake (toString ./.); \
        info = ns: cfgs: builtins.mapAttrs (_: c: { \
          formFactor = c.config.nixma.${ns}.formFactor or "?"; \
          roles = c.config.nixma.${ns}.roles or []; \
        }) cfgs; \
      in { \
        nixos = info "nixos" (f.nixosConfigurations or {}); \
        darwin = info "darwin" (f.darwinConfigurations or {}); \
      } \
    ' \
      | jq -r '"NixOS:", (.nixos | to_entries | sort_by(.key) | .[] | "  \(.key) (\(.value.formFactor)) [\(.value.roles | join(" "))]"), "", "darwin:", (.darwin | to_entries | sort_by(.key) | .[] | "  \(.key) (\(.value.formFactor)) [\(.value.roles | join(" "))]")'

# Show every nixma module imported by a host (NixOS or darwin) plus per-user
# home-manager modules. Auto-detects the platform. Ex: just enabled rock3c | fire
enabled host=`hostname`:
    @nix eval --json --impure --expr ' \
      let \
        f = builtins.getFlake (toString ./.); \
        n = f.nixosConfigurations.{{host}} or null; \
        d = f.darwinConfigurations.{{host}} or null; \
        cfg = if n != null then n.config else d.config; \
        platform = if n != null then "NixOS" else "darwin"; \
        os = cfg.nixma.nixos.imported or (cfg.nixma.darwin.imported or {}); \
      in { \
        inherit platform os; \
        hm = builtins.mapAttrs (_: u: u.nixma.imported or {}) (cfg.home-manager.users or {}); \
      } \
    ' \
      | jq -r '"\(.platform):", (.os | to_entries | sort_by(.key) | .[] | "  \(.key)"), "", (.hm | to_entries | sort_by(.key) | .[] | "HM (\(.key)):", (.value | to_entries | sort_by(.key) | .[] | "  \(.key)"), "")'

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

