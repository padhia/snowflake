{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

, cloudpickle
, protobuf
, python-dateutil
, pyyaml
, setuptools
, snowflake-connector-python
, typing-extensions
, wheel
}:

buildPythonPackage rec {
  pname = "snowflake-snowpark-python";
  version = "1.25.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "snowflake_snowpark_python";
    hash = "sha256-GEufaHO0wxivJyfHBwAJmMn24kVCA25TbYbC4xRUnkc=";
  };

  disabled = pythonOlder "3.8";

  pythonRelaxDeps = [
    "cloudpickle"
  ];

  dependencies = [
    cloudpickle
    protobuf
    python-dateutil
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
