# Snowflake Nix flake

This flake provides Snowflake applications, packages, development shells and an overlay.

## Applications

- `snowflake-cli`: Python package for the official [Snowflake CLI tool](https://pypi.org/project/snowflake-cli/) is packaged as an application
- `snowsql`: Legacy Snowflake CLI tool used for running SQL statements

## Python Packages

- `snowflake-snowpark-python`
- `snowpark-ml-python` (Note: current version does not work due to [`numpy<2` requirement](https://github.com/snowflakedb/snowflake-ml-python/issues/160))
- `snowpark-core` (\*)
- `snowflake-connector-python` (\*)
- `snowflake-sqlalchemy` (\*)

**\*** only available if the latest version of the package in `nixos-unstable` is outdated

## Development shells

Following `devShells` provide Python development environments that include mentioned packages:

name           | Python | Packages
---------------|--------|--------------------------------------------------------
`default`      | 3.13   | `snowflake-connector-python`
`snowpark`     | 3.12   | `snowflake-snowpark-python`
`snowpark313`  | 3.13   | `snowflake-snowpark-python`
`lab`          | 3.13   | `snowflake-connector-python`, `jupyterlab`, `streamlit`
`snowpark-lab` | 3.13   | `snowflake-snowpark-python`, `jupyterlab`, `streamlit`
`ml`           | 3.12   | `snowflake-ml-python`
`ml-lab`       | 3.12   | `snowflake-ml-python` `jupyterlab`

All of the above `devShells` include `pip`, `ruff`, `uv`, and `pytest`

## Overlay

`overlays.default` includes all applications and packages
