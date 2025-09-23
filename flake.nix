{
  description = "Snowflake tools, packages and development shells";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      pyOverlay = py-final: py-prev: {
        protoc-wheel-0 = py-final.callPackage ./protoc-wheel-0.nix { };
        snowflake-ml-python = py-final.callPackage ./snowflake-ml-python.nix { };
        snowflake-snowpark-python = py-final.callPackage ./snowflake-snowpark-python.nix { };
        snowpark-connect = py-final.callPackage ./snowpark-connect.nix { };

        snowflake-connector-python = py-prev.snowflake-connector-python.overridePythonAttrs (old: rec {
          version = "3.17.4";
          src = py-final.pkgs.fetchFromGitHub {
            owner = "snowflakedb";
            repo = "snowflake-connector-python";
            tag = "v${version}";
            hash = "sha256-UnEMhxPi6NdnpL609U8o5lga7+kOLIpqvqMCbJqy1uM=";
          };
          doCheck = false;
        });
      };

      overlays.default = final: prev: {
        snowsql = prev.callPackage ./snowsql.nix { };
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [ pyOverlay ];
      };

      eachSystem = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ self.overlays.default ];
          };

          devShells =
            let
              pyShell =
                pyPkgs: name: addPkgNames:
                pkgs.mkShell {
                  inherit name;
                  venvDir = "./.venv";
                  buildInputs =
                    with pyPkgs;
                    [
                      python
                      pip
                      pkgs.ruff
                      pkgs.uv
                      venvShellHook
                      pytest
                    ]
                    ++ (builtins.map (name: pyPkgs.${name}) addPkgNames);
                };
              py312Shell = pyShell pkgs.python312Packages;
              py313Shell = pyShell pkgs.python313Packages;

            in
            {
              default = py313Shell "snowflake" [
                "snowflake-connector-python"
                "keyring"
              ];
              lab = py313Shell "snowflake-lab" [
                "snowflake-connector-python"
                "keyring"
                "jupyterlab"
                "streamlit"
              ];
              snowpark312 = py312Shell "snowpark" [ "snowflake-snowpark-python" ];
              snowpark = py313Shell "snowpark" [ "snowflake-snowpark-python" ];
              snowpark-lab = py313Shell "snowpark-lab" [
                "snowflake-snowpark-python"
                "jupyterlab"
                "streamlit"
              ];
              ml = py312Shell "ml" [ "snowflake-ml-python" ];
              ml-lab = py312Shell "ml-lab" [
                "snowflake-ml-python"
                "jupyterlab"
              ];

              snowpark-connect = pkgs.mkShell {
                name = "snowpark-connect";
                venvDir = "./.venv";
                buildInputs = with pkgs.python312Packages; [
                  python
                  pip
                  pkgs.ruff
                  pkgs.uv
                  pkgs.jre
                  venvShellHook
                  pytest
                  snowpark-connect
                ];
              };
            };

          packages = {
            inherit (pkgs) snowsql snowflake-cli;
          };

        in
        {
          inherit devShells packages;
        }
      );
    in
    {
      inherit (eachSystem) devShells packages;
      inherit overlays;
    };
}
