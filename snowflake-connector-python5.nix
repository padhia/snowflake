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
  version = "5.2.0";

  platforms = {
    x86_64-linux = {
      cp311 = { platform = "manylinux_2_28_x86_64"; hash = "sha256-EugJTbxJprvL4TB5a5/73GNZJFHmsO608GTmkzu5kk8="; };
      cp312 = { platform = "manylinux_2_28_x86_64"; hash = "sha256-CJ1AI/C82b1SqncbWchYittLGRP1XvWNq2kDXkA3muI="; };
      cp313 = { platform = "manylinux_2_28_x86_64"; hash = "sha256-QYjyHruPdmtjGam9DcXj9jQmj7YuuxzKcMs9Hg+RnkA="; };
      cp314 = { platform = "manylinux_2_28_x86_64"; hash = "sha256-0oJ5ZLrZbY2vVwTmwXfjlhZ8n3cZo5yt1qOeJSA8Mdo="; };
      cp315 = { platform = "manylinux_2_28_x86_64"; hash = "sha256-ONJdKu2XTBaEVQpUjxaKvanBQr36F5vAS+hGz77Iizg="; };
    };
    aarch64-linux = {
      cp311 = { platform = "manylinux_2_28_aarch64"; hash = "sha256-ldivXlM3USiyNWxUe5sG5BjoRzHUG4ZLS5tojdks+dU="; };
      cp312 = { platform = "manylinux_2_28_aarch64"; hash = "sha256-5QVEw53+3k96qXWeyDM5iwLjwqTinJswcW9IyIMwWrU="; };
      cp313 = { platform = "manylinux_2_28_aarch64"; hash = "sha256-6YKEMTwG/A680gd/G30sPPFRPU/TqHJR6+QafoztQ7Y="; };
      cp314 = { platform = "manylinux_2_28_aarch64"; hash = "sha256-Wm2VNXciKuA+5tOLqleOBQ3gJlsAmLGZvc5670tqjIo="; };
      cp315 = { platform = "manylinux_2_28_aarch64"; hash = "sha256-9s4dcNCAaAoJl/D2rKdWA4wHt6FXeij2eVuxXl+a9vs="; };
    };
    x86_64-darwin = {
      cp311 = { platform = "macosx_10_14_x86_64"; hash = "sha256-M01j2Oj13uekO2KtzcLrevRSjuEwqozh5gTDbxNBUqQ="; };
      cp312 = { platform = "macosx_10_14_x86_64"; hash = "sha256-QStl2hdEMHR/zq2HDu4+e3oyGQLSTL6l36XVGXhTDVk="; };
      cp313 = { platform = "macosx_10_14_x86_64"; hash = "sha256-Q14pWm0ljqOqItDL2mAck+QJ93LJ+LXz4flyhhmgXjQ="; };
      cp314 = { platform = "macosx_10_15_x86_64"; hash = "sha256-OeOldd0Vw/2sy+7Bnk57TQrsaHYpFXE9zQIuO+/Oojk="; };
      cp315 = { platform = "macosx_10_15_x86_64"; hash = "sha256-RvMQD9Kr/BgmweOQFHf+8lTZZJ3NNT6vDIelVHv+Kwg="; };
    };
    aarch64-darwin = {
      cp311 = { platform = "macosx_11_0_arm64"; hash = "sha256-cwuhp8Q4Ptyv9XM9FxQzEXoIZKAUGs+Q7VtraIfC6Ac="; };
      cp312 = { platform = "macosx_11_0_arm64"; hash = "sha256-fRnwPo55BhpQw5BsJMrLS7TpQHy+W4etrjeio2b4xoQ="; };
      cp313 = { platform = "macosx_11_0_arm64"; hash = "sha256-o0HjVZ/mXIoJ1tDcRpVKu92cJJ81sb/9YEC/hJRDPwY="; };
      cp314 = { platform = "macosx_11_0_arm64"; hash = "sha256-/tNPwqchA2IyATa1Zeyfx8LTT4DLxEAUQaFpdnqFfMk="; };
      cp315 = { platform = "macosx_11_0_arm64"; hash = "sha256-EDSTyYArJGvJYMQe8LSi2gNA0E/L/TO0YyV1uEauQSI="; };
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
