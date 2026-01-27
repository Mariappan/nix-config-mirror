#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_NIX="$SCRIPT_DIR/default.nix"

OWNER="ahkohd"
REPO="oyo"

echo "Fetching latest commit from GitHub..."
LATEST_COMMIT=$(curl -s "https://api.github.com/repos/$OWNER/$REPO/commits/main" | jq -r '.sha')

if [[ -z "$LATEST_COMMIT" || "$LATEST_COMMIT" == "null" ]]; then
    echo "Error: Could not fetch latest commit"
    exit 1
fi

CURRENT_VERSION=$(grep 'version = ' "$DEFAULT_NIX" | head -1 | sed 's/.*"\([^"]*\)".*/\1/')

echo "Current version: $CURRENT_VERSION"
echo "Latest commit:   $LATEST_COMMIT"

if [[ "$CURRENT_VERSION" == "$LATEST_COMMIT" ]]; then
    echo "Already up to date!"
    exit 0
fi

echo "Updating to $LATEST_COMMIT..."

echo "Fetching new source hash..."
SOURCE_HASH=$(nix-prefetch-url --unpack "https://github.com/$OWNER/$REPO/archive/${LATEST_COMMIT}.tar.gz" 2>/dev/null)
SOURCE_HASH_SRI=$(nix hash convert --hash-algo sha256 --to sri "$SOURCE_HASH")

echo "Source hash: $SOURCE_HASH_SRI"

sed -i "s/version = \"[^\"]*\"/version = \"$LATEST_COMMIT\"/" "$DEFAULT_NIX"
sed -i "s|hash = \"sha256-[^\"]*\"|hash = \"$SOURCE_HASH_SRI\"|" "$DEFAULT_NIX"
sed -i "s|cargoHash = \"sha256-[^\"]*\"|cargoHash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\"|" "$DEFAULT_NIX"

echo "Building to get cargoHash (this may take a while)..."
BUILD_OUTPUT=$(nix-build -E "with import <nixpkgs> {}; callPackage $DEFAULT_NIX {}" 2>&1 || true)

CARGO_HASH=$(echo "$BUILD_OUTPUT" | grep -oP 'got:\s+\Ksha256-[A-Za-z0-9+/=]+' | head -1)

if [[ -z "$CARGO_HASH" ]]; then
    echo "Error: Could not extract cargoHash from build output"
    echo "You may need to update cargoHash manually"
    exit 1
fi

echo "Cargo hash: $CARGO_HASH"
sed -i "s|cargoHash = \"sha256-[^\"]*\"|cargoHash = \"$CARGO_HASH\"|" "$DEFAULT_NIX"

echo "Verifying build..."
if nix-build -E "with import <nixpkgs> {}; callPackage $DEFAULT_NIX {}" >/dev/null 2>&1; then
    echo "Build successful!"
    echo "Updated oyo from $CURRENT_VERSION to $LATEST_COMMIT"
else
    echo "Warning: Build failed. Please check the package manually."
    exit 1
fi
