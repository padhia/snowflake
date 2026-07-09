{
  lib,
  buildPythonPackage,
  pythonRelaxDepsHook,
  fetchPypi,
  pythonOlder,
  setuptools,

  anyio,
  cachetools,
  cloudpickle,
  cmdstanpy,
  cryptography,
  fsspec,
  h2,
  importlib-resources,
  numpy,
  orjson,
  packaging,
  pandas,
  platformdirs,
  pyarrow,
  pydantic,
  pyjwt,
  pytimeparse,
  pyyaml,
  retrying,
  scikit-learn,
  scipy,
  shap,
  snowflake-connector-python,
  snowflake-snowpark-python,
  sqlparse,
  tqdm,
  typing-extensions,
  xgboost,
}:

buildPythonPackage rec {
  pname = "snowflake-ml-python";
  version = "1.46.0";
  pyproject = true;

  src = fetchPypi {
    pname = "snowflake_ml_python";
    inherit version;
    hash = "sha256-rwKmODrS+SEqjPMOmI1Tz0Aq+YHpbj7UQMJYgd/z9Ig=";
  };

  disabled = pythonOlder "3.10";
  pythonRelaxDeps = true;

  build-system = [
    setuptools
    pythonRelaxDepsHook
  ];

  dependencies = [
    anyio
    cachetools
    cloudpickle
    cmdstanpy
    cryptography
    fsspec
    h2
    importlib-resources
    numpy
    orjson
    packaging
    pandas
    platformdirs
    pyarrow
    pydantic
    pyjwt
    pytimeparse
    pyyaml
    retrying
    scikit-learn
    scipy
    shap
    snowflake-connector-python
    snowflake-snowpark-python
    sqlparse
    tqdm
    typing-extensions
    xgboost
  ]
  ++ fsspec.optional-dependencies.http
  ++ snowflake-connector-python.optional-dependencies.pandas;

  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/snowflakedb/snowpark-python/blob/main/CHANGELOG.md";
    description = "Snowflake Python API for Resource Management";
    homepage = "https://docs.snowflake.com/en/developer-guide/snowpark/index";
    license = licenses.asl20;
  };
}
