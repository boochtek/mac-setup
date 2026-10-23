#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

# TODO: Install via ASDF.

## Io
# Install the required XQuartz first. NOTE: Requires password interactively.
brew-install-cask xquartz
# Install the language itself.
brew install --quiet io
