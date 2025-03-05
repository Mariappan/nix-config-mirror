default: build

# Update flake and build nixos
update:
    nix flake update
    nh os switch . -- --accept-flake-config

# Build nixos
build:
    nh os switch . -- --accept-flake-config
