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
, snowflake-snowpark-python
, urllib3
}:

buildPythonPackage rec {
  pname     = "snowflake-core";
  version   = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "snowflake_core";
    inherit version;
    hash = "sha256-0N/HFiXKt1kfO9+UhTUADcOMjKFNV3xkCHXnYjrPfuY=";
  };

  disabled = pythonOlder "3.9";
  pythonRelaxDeps = true;

  nativeBuildInputs = [
    pythonRelaxDepsHook
    hatchling
  ];

  propagatedBuildInputs = [
    pydantic
    python-dateutil
    pyyaml
    requests
    snowflake-snowpark-python
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
