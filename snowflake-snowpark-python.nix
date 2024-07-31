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
  version = "1.20.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "snowflake_snowpark_python";
    hash = "sha256-UU2vyWISE1mn2cPMe0nxna5q8KU/oq2Kan2gK37TP8k=";
  };

  disabled = pythonOlder "3.7";

  pythonRelaxDeps = [
    "cloudpickle"
  ];

  propagatedBuildInputs = [
    setuptools
    wheel
    snowflake-connector-python
    typing-extensions
    pyyaml
    cloudpickle
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
