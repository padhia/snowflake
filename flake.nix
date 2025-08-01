{
  description = "Snowflake tools, packages and development shells";

  inputs.nixpkgs.url     = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
  let
    grpcio5 = py-final: py-prev: rec {
      grpcio5        = py-prev.grpcio.override        { protobuf = py-final.protobuf5; };
      grpcio-tools5  = py-prev.grpcio-tools.override  { protobuf = py-final.protobuf5; grpcio = grpcio5; };
      mypy-protobuf5 = py-prev.mypy-protobuf.override { protobuf = py-final.protobuf5; grpcio-tools = grpcio-tools5; };
      streamlit5     = py-prev.streamlit.override     { protobuf = py-final.protobuf5; };
    };

    pyOverlay = py-final: py-prev: {
      protoc-wheel-0 = py-final.callPackage ./protoc-wheel-0.nix {};
      snowflake-cli  = py-final.callPackage ./snowflake-cli.nix {};
      snowflake-ml-python = py-final.callPackage ./snowflake-ml-python.nix {};
      snowflake-snowpark-python = py-final.callPackage ./snowflake-snowpark-python.nix {
        protobuf = py-final.protobuf5;
        mypy-protobuf = py-final.mypy-protobuf5;
      };

      snowflake-core = py-prev.snowflake-core.overridePythonAttrs(old: rec {
        version = "1.6.0";
        src = py-final.pkgs.fetchPypi {
          pname = "snowflake_core";
          inherit version;
          hash = "sha256-W6itmcyJRdSAlTLxj2asYjrqGIjmhpdcRh+Gp8OXAik=";
        };
      });

      snowflake-connector-python = py-prev.snowflake-connector-python.overridePythonAttrs(old: rec {
        version = "3.16.0";
        src = py-final.pkgs.fetchFromGitHub {
          owner = "snowflakedb";
          repo  = "snowflake-connector-python";
          tag   = "v${version}";
          hash  = "sha256-mow8TxmkeaMkgPTLUpx5Gucn4347gohHPyiBYjI/cDs=";
        };
        doCheck = false;
      });
    };

    overlays.default = final: prev: {
      inherit (final.python312Packages) snowflake-cli;
      snowsql = prev.callPackage ./snowsql.nix {};
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [ grpcio5 pyOverlay ];
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
            pyShell = pyPkgs: name: addPkgNames: pkgs.mkShell {
              inherit name;
              venvDir = "./.venv";
              buildInputs = with pyPkgs; [
                python
                pip
                pkgs.ruff
                pkgs.uv
                venvShellHook
                pytest
              ] ++ (builtins.map (name: pyPkgs.${name}) addPkgNames);
            };
            py312Shell = pyShell pkgs.python312Packages;
            py313Shell = pyShell pkgs.python313Packages;

          in {
            default = py313Shell "snowflake" [ "snowflake-connector-python" ];
            lab = py313Shell "snowflake-lab" [ "snowflake-connector-python" "jupyterlab" "streamlit" ];
            snowpark = py312Shell "snowpark" [ "snowflake-snowpark-python" ];
            snowpark313 = py313Shell "snowpark" [ "snowflake-snowpark-python" ];
            snowpark-lab = py313Shell "snowpark-lab" [ "snowflake-snowpark-python" "jupyterlab" "streamlit" ];
            ml = py312Shell "ml" [ "snowflake-ml-python" ];
            ml-lab = py312Shell "ml-lab" [ "snowflake-ml-python" "jupyterlab" ];
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
