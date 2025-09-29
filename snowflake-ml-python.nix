{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, fetchPypi
, pythonOlder
, setuptools

, absl-py
, anyio
, cachetools
, cloudpickle
, cryptography
, fsspec
, importlib-resources
, numpy
, packaging
, pandas
, pyarrow
, pydantic
, pyjwt
, pytimeparse
, pyyaml
, retrying
, s3fs
, scikit-learn
, scipy
, shap
, snowflake-connector-python
, snowflake-core
, snowflake-snowpark-python
, sqlparse
, typing-extensions
, xgboost
}:

buildPythonPackage rec {
  pname     = "snowflake-ml-python";
  version   = "1.15.0";
  pyproject = true;

  src = fetchPypi {
    pname = "snowflake_ml_python";
    inherit version;
    hash = "sha256-qlqFsvAtkaLoLsVNv7twO6NlNjzMMXg5Jh5pzQcsiBs=";
  };

  disabled = pythonOlder "3.9";
  pythonRelaxDeps = true;

  build-system = [
    setuptools
    pythonRelaxDepsHook
  ];

  dependencies = [
    absl-py
    anyio
    cachetools
    cloudpickle
    cryptography
    fsspec
    importlib-resources
    numpy
    packaging
    pandas
    pyarrow
    pydantic
    pyjwt
    pytimeparse
    pyyaml
    retrying
    s3fs
    scikit-learn
    scipy
    shap
    snowflake-connector-python
    snowflake-snowpark-python
    snowflake-core
    sqlparse
    typing-extensions
    xgboost
  ] ++ fsspec.optional-dependencies.http
    ++ snowflake-connector-python.optional-dependencies.pandas;

  doCheck = false;

  meta = with lib; {
    changelog   = "https://github.com/snowflakedb/snowpark-python/blob/main/CHANGELOG.md";
    description = "Snowflake Python API for Resource Management";
    homepage    = "https://docs.snowflake.com/en/developer-guide/snowpark/index";
    license     = licenses.asl20;
    maintainers = with maintainers; [ padhia ];
  };
}
