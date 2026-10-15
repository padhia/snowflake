{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,

  httpx,
  h2,
  typing-extensions,
  snowflake-connector-python,
}:

buildPythonPackage rec {
  pname = "snowflake-sandbox-python";
  version = "0.2.2a5";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "snowflake_sandbox_python";
    hash = "sha256-AFXuw5NkfLQ5/rhIhSbqwUppScTIgRl/I8iBN7N9SVo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    h2 # httpx[http2]
    typing-extensions
    snowflake-connector-python
  ];

  doCheck = false;
  pythonImportsCheck = [ "snowflake.sandbox" ];

  meta = {
    description = "Snowflake sandboxes — Python SDK and CLI";
    license = lib.licenses.asl20;
  };
}
