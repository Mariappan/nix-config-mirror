default: build

# Update flake and build nixos
update:
    nix flake update

# Build nixos
[linux]
build flake='.':
    # Dryrun to get overview
    nh os switch -n {{flake}} -- --accept-flake-config
    sudo nixos-rebuild switch --flake {{flake}}

# Build nix-darwin
[macos]
build flake='.':
    sudo darwin-rebuild switch --flake {{flake}}

