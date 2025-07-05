default: build

# Update flake and build nixos
update:
    nix flake update

# Build nixos
[linux]
build flake='.':
    nh os switch {{flake}} -- --accept-flake-config

# Build nix-darwin
[macos]
build flake='.':
    sudo darwin-rebuild switch --flake {{flake}}

