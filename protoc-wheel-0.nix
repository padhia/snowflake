{
  lib,
  buildPythonPackage,
  fetchPypi,
  stdenv,
}:

let
  sources = {
    x86_64-linux = {
      platform = "manylinux1_x86_64";
      hash = "sha256-JvvSrlUerOOWzopkRUaTl3WKJ73hZJz6uEEr5fMEmRU=";
    };
    aarch64-linux = {
      platform = "manylinux2014_aarch64";
      hash = "sha256-V1rO3EiT8sIe3iJsGc/sslV29YHDcTEI4rsSV/TdVmg=";
    };
    x86_64-darwin = {
      platform = "macosx_10_6_x86_64";
      hash = "sha256-XBg3SdVlKqgbeY4Peq2IpN1h4ZRr1Yh6E+IOfkpqyjk=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-gsndGK7b1jSXmw5fuNaKAbR3xuFGVEX2kPJz0I2kxH4=";
    };
  };
  platform = sources.${stdenv.system} or (throw "Unsupported platform: ${stdenv.system}");
in
buildPythonPackage rec {
  pname = "protoc-wheel-0";
  version = "21.1";
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    inherit (platform) platform hash;
    pname = "protoc_wheel_0";
  };

  doCheck = false;

  meta = with lib; {
    description = "Google protobuf compiler protoc";
    homepage = "https://pypi.org/project/protoc-wheel-0";
    license = licenses.asl20;
    maintainers = with maintainers; [ padhia ];
    platforms = builtins.attrNames sources;
  };
}
