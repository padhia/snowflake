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

        devShells =
          let
            mkEnv = pyPkgs: name: pkgs.mkShell {
              inherit name;
              venvDir = "./.venv";
              buildInputs = with pyPkgs; [
                python
                pkgs.ruff
                venvShellHook
                build
                pytest
                pyPkgs.${"snowflake-${name}-python"}
              ];
            };
          in {
            default = mkEnv pkgs.python311Packages "snowpark";
            connector = mkEnv pkgs.python3Packages "connector";
          };

        packages = {
          inherit (pkgs) snowsql snowflake-cli;
        };

        apps = {
          snowsql = { type = "app"; program = "${packages.snowsql}/bin/snowsql"; };
          default = { type = "app"; program = "${packages.snowflake-cli}/bin/snow"; };
        };

      in {
        inherit devShells packages apps;
      });
  in {
    inherit (eachSystem) devShells packages apps;
    inherit overlays;
  };
}
