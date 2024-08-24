# trunk-ignore-all(trivy/DS026)
# Start from a base image for python. (https://github.com/microsoft/vscode-dev-containers/tree/main/containers/python-3)
# https://mcr.microsoft.com/v2/vscode/devcontainers/python/tags/list
ARG VARIANT="3.10-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

# Boilerplate
# ? Force the stdout and stderr streams to go straight to terminal.
ENV PYTHONUNBUFFERED=1
# ? Disable pip version check
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
# ? Ensures that any failures in a pipeline of commands will cause the RUN command to fail with the appropriate exit code.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Change user (non-root user for Codespace)
USER vscode

# Change working directory
WORKDIR "/workspaces/dlt-dbt-snowflake-workshop/"

# Install python/Dagster requirements (defined in `setup.py`)
# ? (Will be updated in `postStartCommand.bash`)
# ? We pre-install here to speed up the postStartCommand
COPY setup.py ./
RUN pip install --user --no-cache-dir --no-warn-script-location -e ".[dev]"