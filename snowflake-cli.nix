{ lib
, buildPythonPackage
, hatch-vcs
, fetchFromGitHub
, pythonOlder
, hatchling

, cfgv
, click
, faker
, gitpython
, identify
, iniconfig
, jinja2
, keyring
, nodeenv
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
, virtualenv
, werkzeug
}:

buildPythonPackage rec {
  pname = "snowflake-cli";
  version = "3.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-tiDXcocNKV8av7fciFz0kyS4F66heaLuREJtjwwF2m4=";
  };

  disabled = pythonOlder "3.10";

  pythonRelaxDeps = true;

  build-system = [
    hatch-vcs
    hatchling
    pip
  ];

  dependencies = [
    cfgv
    click
    faker
    gitpython
    identify
    iniconfig
    jinja2
    keyring
    nodeenv
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
    virtualenv
    werkzeug
  ];

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
