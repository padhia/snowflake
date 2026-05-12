{
  fetchFromGitHub,
  snowflake-connector-python,
}:

snowflake-connector-python.overridePythonAttrs (old: rec {
  version = "4.5.0";
  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-connector-python";
    tag = "v${version}";
    hash = "sha256-DhSWmvK0nDizXTlVrRKymUHqhd6C1ALl4y+HtA9hPK8=";
  };
  doCheck = false;

  preBuild = ''
    export SNOWFLAKE_NO_BOTO=1
  '';
})
