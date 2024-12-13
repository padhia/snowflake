{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, fetchPypi
, pythonOlder
, hatchling

, atpublic
, pydantic
, python-dateutil
, pyyaml
, requests
, snowflake-snowpark-python
, urllib3
}:

buildPythonPackage rec {
  pname     = "snowflake-core";
  version   = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "snowflake_core";
    inherit version;
    hash = "sha256-i/Jn/x780X8VdDLG4k9tLrbCru1m9DqzSyFap22O3wI=";
  };

  disabled = pythonOlder "3.7";
  pythonRelaxDeps = true;

  nativeBuildInputs = [
    pythonRelaxDepsHook
    hatchling
  ];

  propagatedBuildInputs = [
    atpublic
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
