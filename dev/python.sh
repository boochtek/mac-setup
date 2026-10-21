#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

# Dependencies: `mise`

## Install Python. (The version comes from the mise config in the config files.)
mise install python
# TODO: See if there are any old versions we want to get rid of. Maybe ask?

# UV is the new Python package manager.
brew install --quiet uv

# Install/upgrade Python command-line tools, each in its own environment.
for tool in virtualenv flake8 black pylint pytest; do
    uv tool install --quiet --upgrade "$tool"
done

# Install/upgrade the libraries we want in the global Python, for quick scripts and the REPL.
mise exec python -- uv pip install --quiet --system --upgrade setuptools pandas numpy matplotlib yfinance

# Ruff is the new formatter and linter for Python. Start using it.
brew install --quiet ruff

