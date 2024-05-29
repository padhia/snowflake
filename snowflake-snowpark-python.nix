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
  version = "1.18.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "snowflake_snowpark_python";
    hash = "sha256-11VuuSy6Zt3++lD+YtQTnTbu0O4yypzWdKkJQmiaGv8=";
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
