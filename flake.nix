{
  description = "Snowflake tools, packages and development shells";

  inputs.nixpkgs.url     = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
  let
    mkPyPkgs = pkgs: py: with pkgs;
      let
        callPackage = lib.callPackageWith pkgs.${py}.pkgs;
        snowflake-connector-python = callPackage ./snowflake-connector-python.nix {};
        snowflake-snowpark-python = callPackage ./snowflake-snowpark-python.nix { inherit snowflake-connector-python; };
        snowflake-core = callPackage ./snowflake-core.nix { inherit snowflake-snowpark-python; };
        snowflake-cli = callPackage ./snowflake-cli.nix { inherit snowflake-connector-python snowflake-core; };
      in {
        inherit snowflake-connector-python snowflake-snowpark-python snowflake-cli;
      };

    defaultPython = pkgs: with pkgs; lib.replaceStrings ["."] [""] python3.libPrefix;

    bySystemOutputs =
      flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs    = import nixpkgs { inherit system; config.allowUnfree = true; };
        pythons = ["python311" "python312"];
        python3 = defaultPython pkgs;

        pyPkgs = mkPyPkgs pkgs;

        devShells =
          let
            mkDevShell = py:
              pkgs.mkShell {
                name = "snowflake";
                venvDir = "./.venv";
                buildInputs = with pkgs.python311Packages; [
                  python
                  pkgs.ruff
                  venvShellHook
                  build
                  pytest
                  (pyPkgs py).snowflake-connector-python
                  (pyPkgs py).snowflake-snowpark-python
                ];
              };

            allPys = pkgs.lib.genAttrs pythons mkDevShell;

          in
            allPys // { default = allPys.${python3}; };

        packages = with pkgs;
          let
            allPys  = lib.genAttrs pythons pyPkgs;
            allPkgs = lib.mapAttrs' (k: v: lib.nameValuePair (k + "Packages") v) allPys;
            snowsql = callPackage ./snowsql.nix {};
            snowflake-cli = allPys.${python3}.snowflake-cli;
          in
            allPkgs // { inherit snowsql snowflake-cli; };

        apps = {
          snowsql.type    = "app";
          snowsql.program = "${packages.snowsql}/bin/snowsql";
          snow.type       = "app";
          snow.program    = "${packages.snowflake-cli}/bin/snow";
        };

      in {
        inherit devShells packages apps;
      });

  in {
    inherit (bySystemOutputs) devShells packages apps;

    overlays = {
      snowsql = final: prev: { snowsql = prev.callPackage ./snowsql.nix {}; };
      snowflake-cli = final: prev:
        let
          python3 = defaultPython prev;
          pyPkgs  = mkPyPkgs prev python3;
        in {
          snowsql = prev.callPackage ./snowsql.nix {};
          snowflake-cli = pyPkgs.snowflake-cli;
        };
    };
  };
}
