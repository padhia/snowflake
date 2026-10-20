{
  fetchPypi,
  typer,
  click,
}:

typer.overridePythonAttrs (old: rec {
  version = "0.24.0";
  src = fetchPypi {
    pname = "typer";
    inherit version;
    hash = "sha256-+Tc9xO/5ATUGlPUZ94PCm216EQ/A3MEbHX41O4XKZQQ=";
  };
  dependencies = (old.dependencies or [ ]) ++ [ click ];
  doCheck = false;
})
