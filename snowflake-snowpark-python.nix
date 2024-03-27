{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonRelaxDepsHook

, setuptools
, wheel
, snowflake-connector-python
, typing-extensions
, pyyaml
, cloudpickle
}:

buildPythonPackage rec {
  pname = "snowflake-snowpark-python";
  version = "1.14.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9CSDxm62267Qd84SVf9QXgskD7zXfm+qO1xwdYFi0+c=";
  };

  disabled = pythonOlder "3.7";

  pythonRelaxDeps = [
    "cloudpickle"
  ];

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
