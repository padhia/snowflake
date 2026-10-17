#!/usr/bin/env bash
set -euo pipefail

# Packages that nix-update can auto-detect versions for (PyPI / GitHub)
packages=(
  snowflake-cli
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
#   snowflake-connector-python5 - per-platform/per-python wheels with individual hashes

for pkg in "${packages[@]}"; do
  echo ">>> Updating $pkg"
  nix run nixpkgs#nix-update -- --flake "$pkg" "$@" || echo "  !! $pkg update failed, skipping"
done
