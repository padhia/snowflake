{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, fetchPypi
, pythonOlder
, hatchling

, coverage
, jinja2
, pluggy
, pyyaml
, rich
, requests
, requirements-parser
, setuptools
, snowflake-connector-python
, strictyaml
, tomlkit
, typer
, urllib3
, gitpython
, keyring
}:

buildPythonPackage rec {
  pname     = "snowflake-cli-labs";
  version   = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C/J+E2LtEAi/fopcmc+3S0ieSC7I4OAXOn1bHBPd9vk=";
  };

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    pythonRelaxDepsHook
    hatchling
  ];

  pythonRelaxDeps = [
    "coverage"
    "gitpython"
    "setuptools"
    "snowflake-connector-python"
  ];

  propagatedBuildInputs = [
    coverage
    jinja2
    pluggy
    pyyaml
    rich
    requests
    requirements-parser
    setuptools
    snowflake-connector-python
    strictyaml
    tomlkit
    typer
    urllib3
    gitpython
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
