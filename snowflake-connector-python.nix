{
  fetchFromGitHub,
  snowflake-connector-python,
}:

snowflake-connector-python.overridePythonAttrs (old: rec {
  version = "4.8.1";
  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-connector-python";
    tag = "v${version}";
    hash = "sha256-Jz2HzSwio1RNx5Fl7QX+1AQ43DYsnLZHnC8BJTreLiU=";
  };
  doCheck = false;
  pythonRelaxDeps = true; # FIXME: update ceritii to 2026.10.23

  preBuild = ''
    export SNOWFLAKE_NO_BOTO=1
  '';
})
