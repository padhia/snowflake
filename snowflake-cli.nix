{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, fetchPypi
, pythonOlder
, hatchling

, jinja2
, pluggy
, pyyaml
, rich
, requests
, requirements-parser
, setuptools
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
  version   = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "snowflake_cli_labs";
    inherit version;
    hash = "sha256-qkwSp6F0rWvl1yfhWx6Spxmxk76R8T8pXSThJ0HY8Rc=";
  };

  disabled = pythonOlder "3.7";
  pythonRelaxDeps = true;

  nativeBuildInputs = [
    pythonRelaxDepsHook
    hatchling
  ];

  propagatedBuildInputs = [
    jinja2
    pluggy
    pyyaml
    rich
    requests
    requirements-parser
    setuptools
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
