{
  description = "Snowflake tools, packages and development shells";

  inputs.nixpkgs.url     = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
  let
    pyOverlay = py-final: py-prev: rec {
      grpcio5        = py-prev.grpcio.override        { protobuf = py-final.protobuf5; };
      grpcio-tools5  = py-prev.grpcio-tools.override  { protobuf = py-final.protobuf5; grpcio = grpcio5; };
      mypy-protobuf5 = py-prev.mypy-protobuf.override { protobuf = py-final.protobuf5; grpcio-tools = grpcio-tools5; };

      snowflake-connector-python = py-final.callPackage ./snowflake-connector-python.nix {};
      protoc-wheel-0             = py-final.callPackage ./protoc-wheel-0.nix {};
      snowflake-core             = py-final.callPackage ./snowflake-core.nix {};
      snowflake-cli              = py-final.callPackage ./snowflake-cli.nix {};
      snowflake-ml-python        = py-final.callPackage ./snowflake-ml-python.nix {};
      snowflake-snowpark-python  = py-final.callPackage ./snowflake-snowpark-python.nix {
        protobuf = py-final.protobuf5;
        mypy-protobuf = mypy-protobuf5;
      };

      snowflake-sqlalchemy = py-prev.snowflake-sqlalchemy.overridePythonAttrs(old: rec {
        version = "1.7.4";
        src = py-final.pkgs.fetchFromGitHub {
          owner = "snowflakedb";
          repo  = "snowflake-sqlalchemy";
          tag   = "v${version}";
          hash  = "sha256-Twv8ugLrQT9y4wHNo0B8vkWOFNSci/t4eY9XvFlq/TE=";
        };
      });
    };

    overlays.default = final: prev: {
      inherit (final.python3Packages) snowflake-cli;
      snowsql = prev.callPackage ./snowsql.nix {};
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [ pyOverlay ];
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
                pip
                pkgs.ruff
                venvShellHook
                build
                pytest
                pyPkgs.${"snowflake-${name}-python"}
              ];
            };
          in {
            default = mkEnv pkgs.python3Packages "snowpark";
            connector = mkEnv pkgs.python3Packages "connector";
            ml = mkEnv pkgs.python3Packages "ml";
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
