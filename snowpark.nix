{ lib
, buildPythonPackage
, fetchPypi

, setuptools
, wheel
, snowflake-connector-python
, typing-extensions
, pyyaml
, cloudpickle
}:

buildPythonPackage rec {
  pname = "snowflake-snowpark-python";
  version = "1.13.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3rpvgil/02jQ7EyNj1FPWwIgNQJLE7DyVCCxI3S/wP0=";
  };

  propagatedBuildInputs = [
    setuptools
    wheel
    snowflake-connector-python
    typing-extensions
    pyyaml
    cloudpickle
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
