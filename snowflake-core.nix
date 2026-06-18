{
  fetchPypi,
  snowflake-core,
}:

snowflake-core.overridePythonAttrs (old: rec {
  version = "1.12.1";
  src = fetchPypi {
    pname = "snowflake_core";
    inherit version;
    hash = "sha256-bLECcQHXxtoS/vZQQf8qUahaOU27HwrAlQAMoFTyan4=";
  };
  doCheck = false;
})
