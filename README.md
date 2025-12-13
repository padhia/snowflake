# Snowflake Nix flake

This flake provides Snowflake applications, packages, development shells and an overlay.

## Applications

- `snowflake-cli`: Python package for the official [Snowflake CLI tool](https://pypi.org/project/snowflake-cli/) is packaged as an application
- `snowsql`: Legacy Snowflake CLI tool used for running SQL statements

## Python Packages

- `snowflake-snowpark-python`
- `snowpark-core` (1)
- `snowflake-connector-python` (1)
- `snowflake-sqlalchemy` (1)
- `snowpark-ml-python` (2)
- `snowflake-labs-mcp`
- `modin`

1. Only available if the latest version of the package in `nixos-unstable` is outdated
2. Frequently broken due to not supporting more recent versions of dependencies available in `nixpkgs`

## Development shells

Following `devShells` provide Python development environments that include mentioned packages:

name           | Python | Packages
---------------|--------|--------------------------------------------------------
`default`      | 3.13   | `snowflake-connector-python`
`snowpark`     | 3.13   | `snowflake-snowpark-python`
`snowpark312`  | 3.12   | `snowflake-snowpark-python`
`lab`          | 3.13   | `snowflake-connector-python`, `jupyterlab`, `streamlit`
`snowpark-lab` | 3.13   | `snowflake-snowpark-python`, `jupyterlab`, `streamlit`
`ml`           | 3.12   | `snowflake-ml-python`
`ml-lab`       | 3.12   | `snowflake-ml-python` `jupyterlab`

All of the above `devShells` include `pip`, `ruff`, `uv`, and `pytest`

## Overlay

`overlays.default` includes all applications and packages
