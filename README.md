# Snowflake Nix flake

This flake provides Snowflake applications, packages, development shells and an overlay.

## Applications
- `snowflake-cli`: Python package for the official [Snowflake CLI tool](https://pypi.org/project/snowflake-cli/) is packaged as an application
- `snowsql`: Legacy Snowflake CLI tool used for running SQL statements

## Python Packages
- `snowflake-snowpark-python`
- `snowpark-ml-python`
- `snowpark-core`
- `snowflake-connector-python` Note: Since this package is already available in `nixpkgs`, it will be included when the `nixpkgs` version is too old to build other packages

## Development shells

Following `devShells` provide Python development environments with several Snowflake Python packages installed:

- `connector`: Creates a Python virtual environment that Includes `snowflake-connector-python` package along with several development Python packages (`pip`, `ruff`, `build`, `pytest`)
- `default`: Similar to above with the addition of `snowflake-snowpark-python` package
- `ml`: Adds `snowflake-ml-python` package to the `default` dev shell

## Overlay

`overlays.default` includes all applications and packages
