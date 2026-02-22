{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,

  pandas,
  packaging,
  numpy,
  fsspec,
  psutil,
  typing-extensions,

  dask,
  distributed,

  ray,
  pyarrow,
}:

buildPythonPackage rec {
  pname = "modin";
  version = "0.37.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "modin";
    hash = "sha256-QO2+r8K44H/aYis4R17AtNWAy48M35kH8cWMHYS5p5Y=";
  };

  disabled = pythonOlder "3.9";

  build-system = [
    setuptools
  ];

  dependencies = [
    pandas
    packaging
    numpy
    fsspec
    psutil
    typing-extensions
  ];

  optional-dependencies = {
    dask = [
      dask
      distributed
    ];
    ray = [
      ray
      pyarrow
    ];
  };

  doCheck = false;

  meta = with lib; {
    description = "Modin: Scale your Pandas workflows by changing a single line of code";
    homepage = "https://github.com/modin-project/modin";
    license = licenses.asl20;
    maintainers = with maintainers; [ padhia ];
  };
}
