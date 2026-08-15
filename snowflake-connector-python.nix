{
  fetchFromGitHub,
  snowflake-connector-python,
}:

snowflake-connector-python.overridePythonAttrs (old: rec {
  version = "4.7.2";
  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-connector-python";
    tag = "v${version}";
    hash = "sha256-O7FyZOQmRH5kkhPQDRNJD2ydjW6R6eFLUv+6/DGMQbQ=";
  };
  doCheck = false;

  preBuild = ''
    export SNOWFLAKE_NO_BOTO=1
  '';
})
