{
  fetchPypi,
  snowflake-core,
}:

snowflake-core.overridePythonAttrs (old: rec {
  version = "1.13.1";
  src = fetchPypi {
    pname = "snowflake_core";
    inherit version;
    hash = "sha256-nweqQPd/HjAvGIEkh6+v1J9/0rSTkuoD8RW8WrbLABU=";
  };
  doCheck = false;
})
