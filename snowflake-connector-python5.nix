{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonOlder,
  autoPatchelfHook,

  cryptography,
  protobuf,
  pytz,
  tomlkit,
  pandas,
  pyarrow,
}:

# Snowflake Python connector v5, built on the Rust-based universal driver.
# Installed from pre-built wheels (the sdist requires a full cargo workspace build);
# on Linux autoPatchelfHook rewrites the native extensions to use Nix store libraries.
let
  version = "5.0.0";

  platforms = {
    x86_64-linux = {
      cp311 = { platform = "manylinux_2_28_x86_64"; hash = "sha256-j0aMmw8UM6QbXsRvAwqWZWn0CyOYglo3M7PvIksS/+8="; };
      cp312 = { platform = "manylinux_2_28_x86_64"; hash = "sha256-qXFgyY2d3sr4MpoiI/FWkVZrpoHos6f9gn7pwl5HMoc="; };
      cp313 = { platform = "manylinux_2_28_x86_64"; hash = "sha256-BxowIRSf2lMeQmFX2rDRN8dy9c24nQNRajqsdRkmGDc="; };
      cp314 = { platform = "manylinux_2_28_x86_64"; hash = "sha256-dOtoC2nvj2mQxCpmvZiD6y4lIHpcrvnjZsz1F+klkog="; };
    };
    aarch64-linux = {
      cp311 = { platform = "manylinux_2_28_aarch64"; hash = "sha256-CjN3BiHymis32bfrIAYDAMAjaKsJzUrXiuvqK3mcg+Q="; };
      cp312 = { platform = "manylinux_2_28_aarch64"; hash = "sha256-rHkw2XBwclHvZkbrmO+Og2xARkLCDcDRXRWXlisll7w="; };
      cp313 = { platform = "manylinux_2_28_aarch64"; hash = "sha256-8gD9iLMlXGSaHq9/LCT3tbXpPyslAgqwPWuNBVIAUU4="; };
      cp314 = { platform = "manylinux_2_28_aarch64"; hash = "sha256-OSay3w9XzmcgL+fVw5nwJugG/i9UMaUDkhUEPVdN5zA="; };
    };
    x86_64-darwin = {
      cp311 = { platform = "macosx_10_14_x86_64"; hash = "sha256-qjfyPkapOdiul975PCJKuI1pzu4M5ZDvCkMwT0Zn3jA="; };
      cp312 = { platform = "macosx_10_14_x86_64"; hash = "sha256-cEK1j86v/OvyFWLkFE/jwi++VibzvN6LRyNkaIGPuQg="; };
      cp313 = { platform = "macosx_10_14_x86_64"; hash = "sha256-ghawBupcCPSuHhTERA249IgcZxaQ9zyJAn+BzLLwzA4="; };
      cp314 = { platform = "macosx_10_15_x86_64"; hash = "sha256-gzSK7OcP0K0OTmDXFjYYjWnoBnL8uH0gL6uDIXqU47c="; };
    };
    aarch64-darwin = {
      cp311 = { platform = "macosx_11_0_arm64"; hash = "sha256-/xKAJCp3oDYvsFchPBvAcerpDmzqvFBeCymTAcpWO8c="; };
      cp312 = { platform = "macosx_11_0_arm64"; hash = "sha256-Iyb6euRNXZFj1wu4LhIxfphkQT/Y2sIGIDtHsbp+Lgk="; };
      cp313 = { platform = "macosx_11_0_arm64"; hash = "sha256-MzA9FX8kV/Q5iVriBIX3uT5+I7S/wT9xTD3LIbn17bM="; };
      cp314 = { platform = "macosx_11_0_arm64"; hash = "sha256-d86MAG4Mdl+suLb7BaIMhwRGAtChan7AnHefOAmVkYM="; };
    };
  };

  pyTag = "cp" + lib.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  wheel =
    platforms.${stdenv.system}.${pyTag}
      or (throw "snowflake-connector-python5: unsupported platform/python ${stdenv.system}/${pyTag}");
in
buildPythonPackage {
  pname = "snowflake-connector-python";
  inherit version;
  format = "wheel";
  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit version;
    inherit (wheel) platform hash;
    pname = "snowflake_connector_python";
    format = "wheel";
    python = pyTag;
    abi = pyTag;
    dist = pyTag;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dependencies = [
    cryptography
    protobuf
    pytz
    tomlkit
  ];

  optional-dependencies = {
    pandas = [
      pandas
      pyarrow
    ];
    pyarrow = [ pyarrow ];
  };

  doCheck = false;
  pythonImportsCheck = [ "snowflake.connector" ];

  meta = {
    description = "Snowflake Connector for Python (universal driver based)";
    homepage = "https://github.com/snowflakedb/drivers/tree/main/python";
    license = lib.licenses.asl20;
    platforms = builtins.attrNames platforms;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
