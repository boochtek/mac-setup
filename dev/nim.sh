#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

## Install Nim via ASDF.
#asdf plugin update nim
#asdf install nim 1.4.2

# NOTE: I'd prefer to install via Mise, but it's hanging on install.
# NOTE: Tried `ASDF_NIM_REMOVE_TEMP=no ASDF_NIM_DEBUG=yes mise install nim@latest`
#mise install nim@latest
brew install --quiet nim

code --install-extension nimlang.nimlang
