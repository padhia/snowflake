{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, fetchPypi
, pythonOlder
, hatchling

, atpublic
, pydantic
, python-dateutil
, snowflake-snowpark-python
, urllib3
}:

buildPythonPackage rec {
  pname     = "snowflake-core";
  version   = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    pname = "snowflake_core";
    inherit version;
    hash = "sha256-qyc6vR4+46kzYZjMLhx/HDn4ZQJvTRceRjLK3/ErLmw=";
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
