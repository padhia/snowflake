{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonRelaxDepsHook

, setuptools
, wheel
, snowflake-connector-python
, typing-extensions
, pyyaml
, cloudpickle
}:

buildPythonPackage rec {
  pname = "snowflake-snowpark-python";
  version = "1.23.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "snowflake_snowpark_python";
    hash = "sha256-R/ZJrTpzmd3TvHFPpC2YRc7L0mADkyDEBuVHG+szSjU=";
  };

  disabled = pythonOlder "3.8";

  pythonRelaxDeps = [
    "cloudpickle"
  ];

  dependencies = [
    cloudpickle
    pyyaml
    setuptools
    snowflake-connector-python
    typing-extensions
    wheel
  ];

  doCheck = false;

  pythonImportsCheck = [
    "snowflake"
    "snowflake.snowpark"
  ];

  meta = with lib; {
    description = "Snowflake Snowpark Python API";
    homepage = "https://github.com/snowflakedb/snowpark-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ padhia ];
  };
}
