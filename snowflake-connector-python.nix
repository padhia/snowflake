{
  fetchFromGitHub,
  snowflake-connector-python,
}:

snowflake-connector-python.overridePythonAttrs (old: rec {
  version = "4.4.0";
  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-connector-python";
    tag = "v${version}";
    hash = "sha256-fgvqUBs6uuf9A8ZEsw1LfpqKXOtGNWRL+Q/2NQqv3ig=";
  };
  doCheck = false;

  preBuild = ''
    export SNOWFLAKE_NO_BOTO=1
  '';
})
