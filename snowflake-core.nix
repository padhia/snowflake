{
  fetchPypi,
  snowflake-core,
}:

snowflake-core.overridePythonAttrs (old: rec {
  version = "1.14.0";
  src = fetchPypi {
    pname = "snowflake_core";
    inherit version;
    hash = "sha256-cwHzj6my8QAJQjoRY3hy2jBaXm7o0qcNwc+asZc+VqY=";
  };
  doCheck = false;
  pythonRelaxDeps = true; # FIXME: update to certifi:2026.10.23
})
