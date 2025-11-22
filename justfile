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

