#!/usr/bin/env bash
set -euo pipefail

# Packages that nix-update can auto-detect versions for (PyPI / GitHub)
packages=(
  snowflake-cli
  snowflake-labs-mcp
  snowflake-connector-python
  snowflake-core
  snowflake-snowpark-python
  snowflake-ml-python
  modin
  snowpark-connect
)

# Skipped:
#   snowsql        - fetches RPMs from a custom URL, not a recognized registry
#   protoc-wheel-0 - platform-specific wheel with per-arch hashes

for pkg in "${packages[@]}"; do
  echo ">>> Updating $pkg"
  nix run nixpkgs#nix-update -- --flake "$pkg" "$@" || echo "  !! $pkg update failed, skipping"
done
