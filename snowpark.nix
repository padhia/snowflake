{ lib
, buildPythonPackage
, fetchPypi
, snowflake-connector-python
, setuptools
, wheel
, cloudpickle
, pyyaml
}:

buildPythonPackage rec {
  pname = "snowflake-snowpark-python";
  version = "1.11.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HwPLVGzHUCZwNu4ZhoVAdf2DNJxjRhqgG/G8SnFVvgE=";
  };

  propagatedBuildInputs = [
    snowflake-connector-python
    setuptools
    wheel
    cloudpickle
    pyyaml
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
