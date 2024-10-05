{
  description = "Snowflake tools, packages and development shells";

  inputs.nixpkgs.url     = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
  let
    overlays.default = final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (
          python-final: python-prev: {
            typer = python-prev.typer.overridePythonAttrs (old: rec {
              pname = "typer";
              version = "0.12.5";
              src =   python-final.fetchPypi {
                inherit pname version;
                hash = "sha256-9ZLwib7cyOwbl0El1khRApw7GvFF8ErKZNaUEPDJtyI=";
              };
            });
            snowflake-snowpark-python = python-final.callPackage ./snowflake-snowpark-python.nix {};
            snowflake-core = python-final.callPackage ./snowflake-core.nix {};
            snowflake-cli = python-final.callPackage ./snowflake-cli.nix {};
          }
        )
      ];
    };

    eachSystem = flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ self.overlays.default ];
        };

        devShells.default = pkgs.mkShell {
          name = "snowflake";
          venvDir = "./.venv";
          buildInputs = with pkgs.python311Packages; [
            python311
            pkgs.ruff
            venvShellHook
            build
            pytest
            snowflake-snowpark-python
          ];
        };

        packages = {
          snowsql = pkgs.callPackage ./snowsql.nix {};
          snowflake-cli = pkgs.python311Packages.callPackage ./snowflake-cli.nix {};
        };

        apps = {
          snowsql.type    = "app";
          snowsql.program = "${packages.snowsql}/bin/snowsql";
          default.type    = "app";
          default.program = "${packages.snowflake-cli}/bin/snow";
        };

      in {
        inherit devShells packages apps;
      });
  in {
    inherit (eachSystem) devShells packages apps;
    inherit overlays;
  };
}
