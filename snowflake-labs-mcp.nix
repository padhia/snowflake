{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "snowflake-labs-mcp";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "snowflake_labs_mcp";
    hash = "sha256-NaCaGZ3BkHrCqyb7UrHkTlwDci0OzkKWvKSkkjQRTAY=";
  };

  disabled = python3Packages.pythonOlder "3.11";

  pythonRelaxDeps = true;

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  dependencies =
    with python3Packages;
    [
      fastmcp
      mcp
      pydantic
      pyyaml
      requests
      snowflake-connector-python
      snowflake-core
      sqlglot
    ]
    ++ [ mcp.optional-dependencies.cli ];

  doCheck = false;

  meta = with lib; {
    description = "Snowflake MCP Server";
    homepage = "https://github.com/Snowflake-Labs/mcp";
    license = licenses.asl20;
  };
}
