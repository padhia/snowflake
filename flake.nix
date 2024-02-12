{
  description = "Snowflake tools, packages and development shells";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    forAllSystems = fn:
      let
        systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      in
        nixpkgs.lib.genAttrs systems (system:
          fn (import nixpkgs { inherit system; config = { allowUnfree = true; }; })
        );

    overlays.snowsql = final: prev: { snowsql = prev.callPackage ./snowsql.nix {}; };

    pyPkgs = { pkgs, python3 }:
      let
        callPackage = pkgs.lib.callPackageWith (pkgs // python3.pkgs // sfPyPkgs);

        sfPyPkgs = {
          snowflake-connector-python = callPackage ./snowflake-connector-python.nix {};
          snowpark  = callPackage ./snowpark.nix {};
          sfconn    = callPackage ./sfconn.nix {};
          sfconn02x = callPackage ./sfconn02x.nix {};
        };
      in sfPyPkgs;

    devShells = forAllSystems (pkgs: with pkgs;
      let
        python3 = python311;
        sfPyPkgs = callPackage pyPkgs { inherit python3; };

        mkPyEnv = name: pyPkg: mkShell {
          inherit name;

          buildInputs = [ pyPkg ] ++ (with python3.pkgs; [
            pkgs.ruff
            pip
            setuptools
            wheel
            build
            pytest
            mypy
          ]);
        };

      in {
        sf-python = mkPyEnv "sf-python" sfPyPkgs.snowflake-connector-python;
        sfconn    = mkPyEnv "sfconn" sfPyPkgs.sfconn;
        sfconn02x = mkPyEnv "sfconn02x" sfPyPkgs.sfconn02x;
        snowpark  = mkPyEnv "snowpark" sfPyPkgs.snowpark;
      });

    packages = forAllSystems (pkgs: { snowsql = pkgs.callPackage ./snowsql.nix {}; });

    apps = forAllSystems (pkgs: {
      snowsql = {
        type = "app";
        program = "${packages.${pkgs.stdenv.hostPlatform.system}.snowsql}/bin/snowsql";
      };
    });

    in {
      inherit devShells packages apps overlays pyPkgs;
    };
}
