# Snowflake Nix Flake

A Nix flake providing Snowflake CLI tools, Python libraries, and development shells.

## Quick Start

```bash
# Enter a development shell with snowflake-connector-python
nix develop github:padhia/snowflake

# Run the Snowflake CLI directly
nix run github:padhia/snowflake#snowflake-cli -- --help

# Enter a Snowpark development environment
nix develop github:padhia/snowflake#snowpark
```

## Applications

| Package | Description | Platforms |
|---------|-------------|-----------|
| `snowflake-cli` | Official [Snowflake CLI](https://docs.snowflake.com/en/developer-guide/snowflake-cli-v2/index) (`snow` command) | Linux, macOS |
| `snowsql` | Legacy SQL CLI for running queries | Linux only |
| `snowflake-labs-mcp` | [Snowflake MCP Server](https://github.com/snowflakedb/mcp) | Linux, macOS |

### Running Applications

```bash
# Run without installing
nix run github:padhia/snowflake#snowflake-cli -- connection list

# Install to profile
nix profile install github:padhia/snowflake#snowflake-cli
```

## Python Packages

The following packages are available via the overlay:

| Package | Description | Notes |
|---------|-------------|-------|
| `snowflake-snowpark-python` | Snowpark Python API | |
| `snowflake-connector-python` | Python connector for Snowflake | Updated when nixpkgs is outdated |
| `snowflake-core` | Core Snowflake library | Updated when nixpkgs is outdated |
| `snowflake-ml-python` | Snowflake ML library | May break with newer dependencies |
| `snowpark-connect` | Spark Connect API for Snowpark | Requires JRE |
| `modin` | Scalable pandas replacement | |

## Development Shells

Pre-configured environments for Snowflake development. All shells include: `python`, `pip`, `ruff`, `uv`, `pytest`, and `venvShellHook`.

| Shell | Python | Packages |
|-------|--------|----------|
| `default` | 3.13 | `snowflake-connector-python`, `keyring` |
| `lab` | 3.13 | `snowflake-connector-python`, `keyring`, `jupyterlab`, `streamlit` |
| `snowpark` | 3.13 | `snowflake-snowpark-python` |
| `snowpark312` | 3.12 | `snowflake-snowpark-python` |
| `snowpark-lab` | 3.13 | `snowflake-snowpark-python`, `jupyterlab`, `streamlit` |
| `ml` | 3.13 | `snowflake-ml-python` |
| `ml-lab` | 3.13 | `snowflake-ml-python`, `jupyterlab` |
| `snowpark-connect` | 3.12 | `snowpark-connect` (includes JRE) |

### Using Development Shells

```bash
# Default shell
nix develop github:padhia/snowflake

# Snowpark with JupyterLab
nix develop github:padhia/snowflake#snowpark-lab

# Use with direnv (add to .envrc)
use flake github:padhia/snowflake#snowpark
```

## Using the Overlay

Add the overlay to your flake to access all packages:

### In a Flake

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    snowflake.url = "github:padhia/snowflake";
  };

  outputs = { nixpkgs, snowflake, ... }:
    let
      system = "x86_64-linux"; # or "aarch64-linux", "x86_64-darwin", "aarch64-darwin"
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ snowflake.overlays.default ];
      };
    in {
      # Use CLI tools
      packages.${system}.default = pkgs.snowflake-cli;

      # Use Python packages
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs.python313Packages; [
          snowflake-snowpark-python
          snowflake-connector-python
        ];
      };
    };
}
```

### In NixOS Configuration

```nix
{ pkgs, ... }:
{
  nixpkgs.overlays = [ inputs.snowflake.overlays.default ];

  environment.systemPackages = [
    pkgs.snowflake-cli
    pkgs.snowsql  # Linux only
  ];
}
```

### In Home Manager

```nix
{ pkgs, ... }:
{
  home.packages = [
    pkgs.snowflake-cli
    (pkgs.python313.withPackages (ps: [
      ps.snowflake-snowpark-python
      ps.snowflake-connector-python
    ]))
  ];
}
```

## Examples

### Create a Snowpark Project Shell

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    snowflake.url = "github:padhia/snowflake";
  };

  outputs = { nixpkgs, snowflake, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ snowflake.overlays.default ];
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          snowflake-cli
          (python313.withPackages (ps: with ps; [
            snowflake-snowpark-python
            pandas
            pytest
          ]))
        ];
      };
    };
}
```

### Use with flake-parts

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    snowflake.url = "github:padhia/snowflake";
  };

  outputs = inputs@{ flake-parts, snowflake, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];

      perSystem = { pkgs, system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ snowflake.overlays.default ];
        };

        devShells.default = pkgs.mkShell {
          packages = [ pkgs.snowflake-cli ];
        };
      };
    };
}
```
