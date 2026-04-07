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
  modin,
  tqdm,
  ipywidgets,
}:

buildPythonPackage rec {
  pname = "snowflake-snowpark-python";
  version = "1.48.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "snowflake_snowpark_python";
    hash = "sha256-MJVVjXzFQxBq2hVfsC5jDwRGcIkZ9cxbKsq5l+uZQz4=";
  };

  disabled = pythonOlder "3.9" || pythonAtLeast "3.15";

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

  optional-dependencies =
    let
      pandas = snowflake-connector-python.optional-dependencies.pandas;
    in
    {
      inherit pandas;
      inherit (snowflake-connector-python.optional-dependencies) secure-local-storage;
      modin = pandas ++ [
        modin
        tqdm
        ipywidgets
      ];
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
  };
}
