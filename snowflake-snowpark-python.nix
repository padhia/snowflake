{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, mypy-protobuf
, protoc-wheel-0

, cloudpickle
, protobuf
, python-dateutil
, pyyaml
, setuptools
, snowflake-connector-python
, typing-extensions
, tzlocal
, wheel
}:

buildPythonPackage rec {
  pname = "snowflake-snowpark-python";
  version = "1.29.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "snowflake_snowpark_python";
    hash = "sha256-z1Wy1JaF+RgGrQOIGVWfdpgJm7KlA6MwbrS8YjVSZOg=";
  };

  disabled = pythonOlder "3.8";

  pythonRelaxDeps = [
    "cloudpickle"
  ];

  build-system = [
    setuptools
    mypy-protobuf
    protoc-wheel-0
  ];

  dependencies = [
    cloudpickle
    protobuf
    python-dateutil
    pyyaml
    setuptools
    snowflake-connector-python
    typing-extensions
    tzlocal
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
