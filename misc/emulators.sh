#!/bin/bash

# Variant of the unofficial Bash strict mode.
set -Euo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"
[[ -n "${DEBUG+unset}" ]] && set -x


# Install FS-UAE Amiga emulator.
brew-install-cask fs-uae fs-uae-launcher



brew-install-cask the-unarchiver
