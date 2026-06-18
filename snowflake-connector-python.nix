{
  fetchFromGitHub,
  snowflake-connector-python,
}:

snowflake-connector-python.overridePythonAttrs (old: rec {
  version = "4.6.0";
  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-connector-python";
    tag = "v${version}";
    hash = "sha256-CwK5AE1flVYFaUpT9YlimMnoRxdY0biRgWbDehoz1SE=";
  };
  doCheck = false;

  preBuild = ''
    export SNOWFLAKE_NO_BOTO=1
  '';
})
