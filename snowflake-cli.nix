{ lib
, buildPythonPackage
, hatch-vcs
, fetchFromGitHub
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
  pname = "snowflake-cli";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-gS2pKoXGZTdvrzzsUlVVPYIowejdCq5+6vOc9DQsyck=";
  };

  disabled = pythonOlder "3.10";

  pythonRelaxDeps = true;

  build-system = [
    hatch-vcs
    hatchling
    pip
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
    changelog = "https://github.com/snowflakedb/snowflake-cli/blob/main/RELEASE-NOTES.md";
    description = "Snowflake Developer CLI";
    homepage = "https://github.com/snowflakedb/snowflake-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ padhia ];
    mainProgram = "snow";
  };
}
