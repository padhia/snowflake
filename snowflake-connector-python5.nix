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
  version = "5.1.0";

  platforms = {
    x86_64-linux = {
      cp311 = { platform = "manylinux_2_28_x86_64"; hash = "sha256-7QUkolAHo4ULnsm2it+jhmym2LMnMxuYCnZWWfkFPfA="; };
      cp312 = { platform = "manylinux_2_28_x86_64"; hash = "sha256-6JnZ1pvH+0CrUxw/NASdBk2uV/zEgF0MKGqjVXDmg94="; };
      cp313 = { platform = "manylinux_2_28_x86_64"; hash = "sha256-j+48HKFWFojl1DKYRQRserTHBpuwA9kps5RZGA0AyH8="; };
      cp314 = { platform = "manylinux_2_28_x86_64"; hash = "sha256-vmDqcScSEsUWnUf7hrLpQGxqYotupqzUEEj5EwHRyZ8="; };
    };
    aarch64-linux = {
      cp311 = { platform = "manylinux_2_28_aarch64"; hash = "sha256-BIzUK0V5wkrRVoW8RpxXrt1lzQBTicFtO631TzcMnuc="; };
      cp312 = { platform = "manylinux_2_28_aarch64"; hash = "sha256-frUzoHXa47drlWfs3LbGbVe5cVbMQ2bzSYQ+SfKVdGo="; };
      cp313 = { platform = "manylinux_2_28_aarch64"; hash = "sha256-7O7T819KYBHWDaSISXV09epYdgLV4os8A6J4TVIqTBk="; };
      cp314 = { platform = "manylinux_2_28_aarch64"; hash = "sha256-r5JGlUQ0p8jjoqonONZkfoqqF0SewTWSwW2vcqwMkRk="; };
    };
    x86_64-darwin = {
      cp311 = { platform = "macosx_10_14_x86_64"; hash = "sha256-MFz+ahonqotENf1bKk1cH2Kt0mwwmGSVQl9qk3q66oE="; };
      cp312 = { platform = "macosx_10_14_x86_64"; hash = "sha256-hvtgys6YndbSd2miv//AteiUCVd2FAAG5sV/1LUGUHA="; };
      cp313 = { platform = "macosx_10_14_x86_64"; hash = "sha256-p9wAnywdy8CK7oNCShNRd5nF0mT1ehtRJfjtLJKuFgI="; };
      cp314 = { platform = "macosx_10_15_x86_64"; hash = "sha256-GwLfncfYQE9Y0YFSJ3vgpjPyfqkez4CA0Z24pd1vbvw="; };
    };
    aarch64-darwin = {
      cp311 = { platform = "macosx_11_0_arm64"; hash = "sha256-8uQJs6QEw0e3F/AHBTarV8YJqZLP32qNChULpK58Qbo="; };
      cp312 = { platform = "macosx_11_0_arm64"; hash = "sha256-Ul7KSvJK7Sf+1IyFAMKixkkLYTs4EyYKhn1EMPwI3L4="; };
      cp313 = { platform = "macosx_11_0_arm64"; hash = "sha256-ZFt1y+zffSXZooqesOolmhECOibZHM19/P1SHhhJNwU="; };
      cp314 = { platform = "macosx_11_0_arm64"; hash = "sha256-6QmSRG4wUxxHaLk0YfRwde6ddmOq9F8Bos+sXHUpx5k="; };
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
