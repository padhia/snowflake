{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonAtLeast
, setuptools

, certifi
, cloudpickle
, fsspec
, jpype1
, protobuf
, s3fs
, snowflake-core
, snowflake-snowpark-python
, sqlglot
, jaydebeapi
, aiobotocore

# The following are dependencies for the vendored pyspark
, py4j
, pandas
, pyarrow
, grpcio
, grpcio-status
, googleapis-common-protos
, numpy
, distutils
}:

buildPythonPackage rec {
  pname = "snowpark-connect";
  version = "0.27.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "snowpark_connect";
    hash = "sha256-vYBU835nbCUR57pgicXAsCoTAoGO1rs3/9MCJW/xEBY=";
  };

  disabled = pythonOlder "3.9" || pythonAtLeast "3.13";

  pythonRelaxDeps = [
    "cloudpickle"
    "protobuf"
    "py4j"
    "grpcio"
    "grpcio-status"
    "numpy"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    certifi
    cloudpickle
    fsspec
    jpype1
    protobuf
    s3fs
    snowflake-core
    snowflake-snowpark-python
    sqlglot
    jaydebeapi
    aiobotocore
    py4j
    pandas
    pyarrow
    grpcio
    grpcio-status
    googleapis-common-protos
    numpy
    distutils
  ] ++ fsspec.optional-dependencies.http ++ snowflake-snowpark-python.optional-dependencies.pandas;

  doCheck = false;

  pythonImportsCheck = [
    "snowflake"
    "snowflake.snowpark_connect"
  ];

  meta = with lib; {
    description = "Snowpark Connect Python API";
    homepage = "https://docs.snowflake.com/en/developer-guide/snowpark-connect/snowpark-connect-overview";
    license = licenses.asl20;
    maintainers = with maintainers; [ padhia ];
  };
}
