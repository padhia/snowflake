{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "protoc-wheel-0";
  version = "21.1";
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "protoc_wheel_0";
    platform = "manylinux1_x86_64";
    hash = "sha256-JvvSrlUerOOWzopkRUaTl3WKJ73hZJz6uEEr5fMEmRU=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Google protobuf compiler protoc";
    homepage = "https://pypi.org/project/protoc-wheel-0";
    license = licenses.asl20;
    maintainers = with maintainers; [ padhia ];
  };
}
