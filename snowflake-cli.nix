{ lib
, buildPythonPackage
, hatch-vcs
, fetchFromGitHub
, pythonOlder
, hatchling

, click
, gitpython
, jinja2
, packaging
, pip
, pluggy
, prompt-toolkit
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
  version = "3.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-qAh9oPx84uiJnAL9PgLLDR/SQVgZtG8xKPSZhW0fxd8=";
  };

  disabled = pythonOlder "3.10";

  pythonRelaxDeps = true;

  build-system = [
    hatch-vcs
    hatchling
    pip
  ];

  dependencies = [
    click
    gitpython
    jinja2
    packaging
    pip
    pluggy
    prompt-toolkit
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
