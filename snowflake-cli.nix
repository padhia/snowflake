{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, fetchPypi
, pythonOlder
, hatchling

, jinja2
, pluggy
, pyyaml
, packaging
, rich
, requests
, requirements-parser
, setuptools
, snowflake-core
, snowflake-connector-python
, tomlkit
, typer
, urllib3
, gitpython
, pip
, pydantic

, keyring
}:

buildPythonPackage rec {
  pname     = "snowflake-cli-labs";
  version   = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "snowflake_cli_labs";
    inherit version;
    hash = "sha256-XzvU0tmI+2ZgPRvLotvWnqGVXNi1YALIo+JNWu9ZXTA=";
  };

  disabled = pythonOlder "3.10";

  pythonRelaxDeps = true;

  build-system = [
    pythonRelaxDepsHook
    hatchling
  ];

  dependencies = [
    jinja2
    pluggy
    pyyaml
    packaging
    rich
    requests
    requirements-parser
    setuptools
    snowflake-core
    snowflake-connector-python
    tomlkit
    typer
    urllib3
    gitpython
    pip
    pydantic
    keyring
  ];

  doCheck = false;

  meta = with lib; {
    changelog   = "https://github.com/snowflakedb/snowflake-cli/blob/main/RELEASE-NOTES.md";
    description = "Snowflake Developer CLI";
    homepage    = "https://github.com/snowflakedb/snowflake-cli";
    license     = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
