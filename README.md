# Snowflake Nix flake

This flake provides various Snowflake packages that are either missing from nixpkgs or are out-of-date.

List of provided artifacts:

## Applications and Packages
- `snowsql`: Now contains, usually, a more up-to-date version of `snowsql`. Historically, the flake provided a patched version of `snowsql` that fixed [this issue](https://github.com/NixOS/nixpkgs/issues/199622). Starting with snowsql version [1.2.30](https://docs.snowflake.com/en/release-notes/clients-drivers/snowsql-2023#version-1-2-30-november-13-2023),  the underlying Snowflake Python connector no longer depends on `oscrypto`, which was needed to be patched.

## Dev shells
- `sf-python`: Python development environment with the latest `snowflake-connector-python` package included
- `sfconn`: Same as `sf-python` plus `sfconn` package
- `snowpark`: Same as `sfconn` plus `snowpark`
