{
  fetchFromGitHub,
  snowflake-connector-python,
}:

snowflake-connector-python.overridePythonAttrs (old: rec {
  version = "4.3.0";
  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-connector-python";
    tag = "v${version}";
    hash = "sha256-bJK6U5lomcPMGeKEmv+9m+uM5+3GJKKUA3dEwP/ynVo=";
  };
  doCheck = false;
})
