{
  fetchFromGitHub,
  snowflake-connector-python,
}:

snowflake-connector-python.overridePythonAttrs (old: rec {
  version = "4.7.5";
  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-connector-python";
    tag = "v${version}";
    hash = "sha256-8RGrZlRkFPidjY49XzEEEEPWCJF9U+8PB1nuD2oqXsE=";
  };
  doCheck = false;

  preBuild = ''
    export SNOWFLAKE_NO_BOTO=1
  '';
})
