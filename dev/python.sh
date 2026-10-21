#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

# Dependencies: `mise`

## Install Python. (The version comes from ~/.config/mise/config.toml.)
mise install python
# Remove old versions, once no config (global or project) still uses them.
mise prune --yes --tools python

# UV is the new Python package manager.
brew install --quiet uv

# Install/upgrade Python command-line tools, each in its own environment.
for tool in virtualenv flake8 black; do
    uv tool install --quiet --upgrade "$tool"
done

# Install/upgrade the libraries we want in the global Python, for quick scripts and the REPL.
# (pylint and pytest go here too, since they need to import the code they check.)
PYTHON_LIBRARIES=(setuptools pandas numpy matplotlib yfinance pylint pytest)
mise exec python -- uv pip install --quiet --system --upgrade "${PYTHON_LIBRARIES[@]}"

# Ruff is the new formatter and linter for Python. Start using it.
brew install --quiet ruff

