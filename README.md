# Snowflake Nix flake

This flake provides various Snowflake packages that are either missing from nixpkgs or are out-of-date.

List of provided artifacts:

## Applications and Packages
- `snowsql`: Now contains (usually) a more up-to-date version than one available from nixpkgs. Historically, the flake provided a patched version of `snowsql` that fixed [this issue](https://github.com/NixOS/nixpkgs/issues/199622). Starting with snowsql version [1.2.30](https://docs.snowflake.com/en/release-notes/clients-drivers/snowsql-2023#version-1-2-30-november-13-2023),  the underlying Snowflake Python connector no longer depends on `oscrypto`, which was needed to be patched.

## Development shells

Creates Python development environment with `snowflake-snowpark-python` and `snowflake-connector-python` packages. Following devShell names correspond to listed Python versions:
- `python311`: Python 3.11
- `python312`: Python 3.12
- `default`: Using Nix's default Python version (`python3`)
