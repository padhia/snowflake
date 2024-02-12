{ lib, buildPythonPackage, fetchPypi, setuptools, snowflake-connector-python }:

buildPythonPackage rec {
  pname = "sfconn";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TTRkeAimw2KLonRCMHwDhsW+VOvaj2te0lQcwJBtKrM=";
  };

  propagatedBuildInputs = [
    snowflake-connector-python
  ];

  nativeBuildInputs = [
    setuptools
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/padhia/sfconn";
    description = "Snowflake connection helper functions";
    maintainers = with maintainers; [ padhia ];
  };
}
