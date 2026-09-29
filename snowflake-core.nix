{
  fetchPypi,
  snowflake-core,
}:

snowflake-core.overridePythonAttrs (old: rec {
  version = "1.13.2";
  src = fetchPypi {
    pname = "snowflake_core";
    inherit version;
    hash = "sha256-SXC+4M6u3X3JAy6rjl3K05NhqLzho78yEWXO1KAbquA=";
  };
  doCheck = false;
})
