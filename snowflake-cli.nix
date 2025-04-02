{ lib
, buildPythonPackage
, hatch-vcs
, fetchFromGitHub
, pythonOlder
, hatchling

, gitpython
, jinja2
, packaging
, pip
, pluggy
, pydantic
, pyyaml
, requests
, requirements-parser
, rich
, setuptools
, snowflake-connector-python
, snowflake-core
, tomlkit
, typer
, urllib3

, keyring
}:

buildPythonPackage rec {
  pname = "snowflake-cli";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-ti8KqiIyDjjnfzdbpfzOwR3sqBYDkNlUylCzovwLKU8=";
  };

  disabled = pythonOlder "3.10";

  pythonRelaxDeps = true;

  build-system = [
    hatch-vcs
    hatchling
    pip
  ];

  dependencies = [
    gitpython
    jinja2
    packaging
    pip
    pluggy
    pydantic
    pyyaml
    requests
    requirements-parser
    rich
    setuptools
    snowflake-connector-python
    snowflake-core
    tomlkit
    typer
    urllib3
    keyring
  ];

  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/snowflakedb/snowflake-cli/blob/main/RELEASE-NOTES.md";
    description = "Snowflake Developer CLI";
    homepage = "https://github.com/snowflakedb/snowflake-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ padhia ];
    mainProgram = "snow";
  };
}
