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
  version = "1.45.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "snowflake_snowpark_python";
    hash = "sha256-K1V9EdA2kQm2IF36++extCsrP/sX81Mh3NU9ZTKSi4A=";
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

  optional-dependencies =
    let
      pandas = snowflake-connector-python.optional-dependencies.pandas;
    in
    {
      inherit pandas;
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
    maintainers = with maintainers; [ padhia ];
  };
}
