{
  lib,
  python3Packages,
  fetchPypi,
  installShellFiles,
}:

python3Packages.buildPythonApplication rec {
  pname = "snowflake-cli";
  version = "3.30.0";
  pyproject = true;

  src = fetchPypi {
    pname = "snowflake_cli";
    inherit version;
    hash = "sha256-MpcJKZ/1lWTdh/7v9zWF/L//FnopB8qJq7SLsx0kzhc=";
  };

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
    pip
  ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies =
    with python3Packages;
    [
      click
      configobj
      gitpython
      pyyaml
      id
      jaraco-context
      jinja2
      keyring
      packaging
      pip
      pluggy
      prompt-toolkit
      protobuf
      pydantic
      python-dotenv
      requests
      requirements-parser
      rich
      setuptools
      snowflake-connector-python
      snowflake-snowpark-python
      snowflake-core
      snowflake-sandbox-python
      tomlkit
      typer_alt
      urllib3
      websocket-client
    ]
    ++ snowflake-connector-python.optional-dependencies.secure-local-storage;

  pythonRelaxDeps = true;

  doCheck = false;

  # postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''

  #   # Looks like the completion generation has some sort of a race
  #   # Occasionally one of the completion generations would fail with
  #   #
  #   # An unexpected exception occurred. Use --debug option to see the traceback. Exception message:
  #   # [Errno 17] File exists: '/build/tmp.W654FVhCPT/.config/snowflake/logs'
  #   #
  #   # This creates a fake config that prevents logging in the build sandbox.
  #   export HOME=$(mktemp -d)
  #   mkdir -p $HOME/.config/snowflake
  #   cat <<EOF > $HOME/.config/snowflake/config.toml
  #   [cli.logs]
  #   save_logs = false
  #   EOF
  #   # snowcli checks the config permissions upon launch and exits with an error code if it's not 0600.
  #   chmod 0600 $HOME/.config/snowflake/config.toml

  #   # Typer tries to guess the current shell by default
  #   export _TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1

  #   installShellCompletion --cmd snow \
  #     --bash <($out/bin/snow --show-completion bash) \
  #     --fish <($out/bin/snow --show-completion fish) \
  #     --zsh <($out/bin/snow --show-completion zsh)
  # '';

  meta = {
    changelog = "https://github.com/snowflakedb/snowflake-cli/blob/main/RELEASE-NOTES.md";
    homepage = "https://docs.snowflake.com/en/developer-guide/snowflake-cli-v2/index";
    description = "Command-line tool explicitly designed for developer-centric workloads in addition to SQL operations";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vtimofeenko ];
    mainProgram = "snow";
  };
}
