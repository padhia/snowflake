{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, cython
, fetchPypi
, pythonOlder
, setuptools
, wheel

, asn1crypto
, cffi
, cryptography
, pyopenssl
, pyjwt
, pytz
, requests
, packaging
, charset-normalizer
, idna
, certifi
, typing-extensions
, filelock
, sortedcontainers
, platformdirs
, tomlkit

, keyring
, pandas
, pyarrow
}:

buildPythonPackage rec {
  pname     = "snowflake-connector-python";
  version   = "3.10.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "snowflake_connector_python";
    hash  = "sha256-uSFNp2znL/+OtgBm/ea5un9YoFXWj/4eepsQNPV6NLQ=";
  };

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    cython
    pythonRelaxDepsHook
    setuptools
    wheel
  ];

  pythonRelaxDeps = [
    "platformdirs"
  ];

  propagatedBuildInputs = [
    asn1crypto
    cffi
    cryptography
    pyopenssl
    pyjwt
    pytz
    requests
    packaging
    charset-normalizer
    idna
    certifi
    typing-extensions
    filelock
    sortedcontainers
    platformdirs
    tomlkit
  ];

  passthru.optional-dependencies = {
    secure-local-storage = [ keyring ];
    pandas = [ pandas pyarrow ];
  };

  # Tests require encrypted secrets, see
  # https://github.com/snowflakedb/snowflake-connector-python/tree/master/.github/workflows/parameters
  doCheck = false;

  pythonImportsCheck = [
    "snowflake"
    "snowflake.connector"
  ];

  meta = with lib; {
    changelog = "https://github.com/snowflakedb/snowflake-connector-python/blob/v${version}/DESCRIPTION.md";
    description = "Snowflake Connector for Python";
    homepage = "https://github.com/snowflakedb/snowflake-connector-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
