{ lib
, buildPythonPackage
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
  version   = "3.12.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "snowflake_connector_python";
    hash  = "sha256-/ZvCqxv1OE0si2W8ALsEdVV9UvBHenESkzSqtT+Wef0=";
  };

  build-system = [
    cython
    setuptools
    wheel
  ];

  dependencies = [
    asn1crypto
    certifi
    cffi
    charset-normalizer
    cryptography
    filelock
    idna
    packaging
    platformdirs
    pyjwt
    pyopenssl
    pytz
    requests
    sortedcontainers
    tomlkit
    typing-extensions
  ];

  passthru.optional-dependencies = {
    pandas = [
      pandas
      pyarrow
    ];
    secure-local-storage = [ keyring ];
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
