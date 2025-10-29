{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pythonAtLeast,
  mypy-protobuf,
  protoc-wheel-0,

  cloudpickle,
  protobuf,
  python-dateutil,
  pyyaml,
  setuptools,
  snowflake-connector-python,
  typing-extensions,
  tzlocal,
  wheel,
}:

buildPythonPackage rec {
  pname = "snowflake-snowpark-python";
  version = "1.42.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "snowflake_snowpark_python";
    hash = "sha256-6ZSzhgyBbRtf3wxicvjZ5BUF5HAUCwY/+UGNI0/YzAA=";
  };

  disabled = pythonOlder "3.9" || pythonAtLeast "3.14";

  pythonRelaxDeps = [
    "cloudpickle"
    "protobuf"
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

  optional-dependencies = {
    "pandas" = [ snowflake-connector-python.optional-dependencies.pandas ];
  };

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
