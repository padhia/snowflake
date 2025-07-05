{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, fetchPypi
, pythonOlder
, hatchling

, pydantic
, python-dateutil
, pyyaml
, requests
, snowflake-connector-python
, urllib3
}:

buildPythonPackage rec {
  pname     = "snowflake-core";
  version   = "1.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "snowflake_core";
    inherit version;
    hash = "sha256-W6itmcyJRdSAlTLxj2asYjrqGIjmhpdcRh+Gp8OXAik=";
  };

  disabled = pythonOlder "3.9";
  pythonRelaxDeps = true;

  build-system = [
    pythonRelaxDepsHook
    hatchling
  ];

  dependencies = [
    pydantic
    python-dateutil
    pyyaml
    requests
    snowflake-connector-python
    urllib3
  ];

  doCheck = false;

  meta = with lib; {
    changelog   = "https://github.com/snowflakedb/snowpark-python/blob/main/CHANGELOG.md";
    description = "Snowflake Python API for Resource Management";
    homepage    = "https://docs.snowflake.com/en/developer-guide/snowpark/index";
    license     = licenses.asl20;
    maintainers = with maintainers; [ padhia ];
  };
}
