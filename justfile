default: build

# Update flake and build nixos
update:
    nh os switch -u . -- --accept-flake-config

# Build nixos
build:
    nh os switch . -- --accept-flake-config
