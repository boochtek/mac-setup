#!/bin/bash

# Dependencies: `asdf`

## Install and configure various versions of Python.
mise install python 3.13
# TODO: See if there are any old versions we want to get rid of. Maybe ask?

# Set the global version of Python, and also use it for this shell.
mise shell python 3.13

# Make sure we're using the right version of Python.
rehash
hash -r

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

