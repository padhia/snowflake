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

    pyModules = { pkgs, py }:
      let
        callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.${py}.pkgs // pyPkgs);
        snowflake-connector-python = callPackage ./snowflake-connector-python.nix {};
        snowpark    = callPackage ./snowpark.nix {};
        pyPkgs      = { inherit snowflake-connector-python snowpark; };
      in pyPkgs;

    devShells = forAllSystems (pkgs: with pkgs;
      let
        mkDevShell = py:
          let
            pyPkgs = callPackage pyModules { inherit pkgs py; };
          in
            mkShell {
              name = "snowflake";
              venvDir = "./.venv";
              buildInputs = with pkgs.python311Packages; [
                python
                pkgs.ruff
                venvShellHook
                build
                pytest
                pyPkgs.snowflake-connector-python
                pyPkgs.snowpark
              ];
            };

        defaultPython3 = lib.replaceStrings ["."] [""] pkgs.python3.libPrefix;

      in {
        python311 = mkDevShell "python311";
        python312 = mkDevShell "python312";
        default   = mkDevShell defaultPython3;
      });

    packages = forAllSystems (pkgs: with pkgs;
      let
        pkgNames     = [ "snowflake-connector-python" "snowpark" ];
        allPkgs      = py: lib.genAttrs pkgNames (pkg: (pyModules { inherit pkgs py; }).${pkg});
        forAllPy     = map (py: { name = "${py}Packages"; value = (allPkgs py); }) ["python311" "python312"];
        allPyAllPkgs = builtins.listToAttrs(lib.flatten(forAllPy));
      in
        allPyAllPkgs // { snowsql = pkgs.callPackage ./snowsql.nix {}; }
    );

    apps = forAllSystems (pkgs: {
      snowsql.type    = "app";
      snowsql.program = "${packages.${pkgs.system}.snowsql}/bin/snowsql";
    });

    in {
      inherit devShells packages apps overlays;
    };
}
