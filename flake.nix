{
  description = "Snowflake tools, packages and development shells";

  inputs.nixpkgs.url     = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
  let
    typer-fix = py-final: py-prev: {
      typer = py-prev.typer.overridePythonAttrs (old: rec {
        pname = "typer";
        version = "0.12.5";
        src =   py-final.fetchPypi {
          inherit pname version;
          hash = "sha256-9ZLwib7cyOwbl0El1khRApw7GvFF8ErKZNaUEPDJtyI=";
        };
        doCheck = false;  # fails on darwin
      });
    };

    pyOverlay = py-final: py-prev: {
      snowflake-snowpark-python = py-final.callPackage ./snowflake-snowpark-python.nix {};
      snowflake-core = py-final.callPackage ./snowflake-core.nix {};
      snowflake-cli  = py-final.callPackage ./snowflake-cli.nix {};
    };

    overlays.default = final: prev: {
      inherit (final.python311Packages) snowflake-cli;
      snowsql = prev.callPackage ./snowsql.nix {};
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [ typer-fix pyOverlay ];
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
          inherit (pkgs) snowsql snowflake-cli;
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
