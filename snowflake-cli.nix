{ lib
, buildPythonPackage
, hatch-vcs
, fetchFromGitHub
, pythonOlder
, hatchling

, click
, gitpython
, id
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
}:

buildPythonPackage rec {
  pname = "snowflake-cli";
  version = "3.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-dJc5q3vE1G6oJq9V4JSPaSyODxKDyhprIwBo39Nu/bA=";
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
    id
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
  ] ++ snowflake-connector-python.optional-dependencies.secure-local-storage;

  doCheck = false;
  dontUsePytestCheck = true; # https://discourse.nixos.org/t/disable-python-testing-in-flake/46381/6

  meta = with lib; {
    changelog = "https://github.com/snowflakedb/snowflake-cli/blob/main/RELEASE-NOTES.md";
    description = "Snowflake Developer CLI";
    homepage = "https://github.com/snowflakedb/snowflake-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ padhia ];
    mainProgram = "snow";
  };
}
