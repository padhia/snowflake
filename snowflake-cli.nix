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
, pip

, keyring
}:

buildPythonPackage rec {
  pname     = "snowflake-cli-labs";
  version   = "2.1.2";
  pyproject = true;

  src = fetchPypi {
    pname = "snowflake_cli_labs";
    inherit version;
    hash = "sha256-I+sAI8nTjJ6K4Cz8GtyudXtdBoZBpDtjsLJd1L/fC8A=";
  };

  disabled = pythonOlder "3.7";
  pythonRelaxDeps = true;

  nativeBuildInputs = [
    pythonRelaxDepsHook
    hatchling
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
    pip
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
