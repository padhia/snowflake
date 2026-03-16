{
  fetchPypi,
  snowflake-core,
}:

snowflake-core.overridePythonAttrs (old: rec {
  version = "1.12.0";
  src = fetchPypi {
    pname = "snowflake_core";
    inherit version;
    hash = "sha256-VchhdTJEuQXbU/akkZFPNJqCl6AGEYmUcxI6WoeGp0c=";
  };
  doCheck = false;
})
