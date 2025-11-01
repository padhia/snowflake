{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "snowflake-labs-mcp";
  version = "1.3.5";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "snowflake_labs_mcp";
    hash = "sha256-BLRcXy1PTq0ketFT6i/9995UaVs+ZqOSIXbZDYMAsnU=";
  };

  disabled = python3Packages.pythonOlder "3.11" || python3Packages.pythonAtLeast "3.14";

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
    maintainers = with maintainers; [ padhia ];
  };
}
