#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

# Dependencies: `mise`

## Install Python. (The version comes from the mise config in the config files.)
mise install python
# TODO: See if there are any old versions we want to get rid of. Maybe ask?

# Install/upgrade all the standard Python packages.
pip install --upgrade pip
pip install --upgrade setuptools
pip install --upgrade virtualenv
pip install --upgrade flake8
pip install --upgrade black
pip install --upgrade pylint
pip install --upgrade pytest
pip install --upgrade pandas
pip install --upgrade numpy
pip install --upgrade matplotlib
pip install --upgrade yfinance

# UV is the new Python package manager. Start using it.
brew install --quiet uv

# Ruff is the new formatter and linter for Python. Start using it.
brew install --quiet ruff

