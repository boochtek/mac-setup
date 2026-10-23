#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

# Install everything needed to re-program my QMK keyboards.
for tap in qmk/qmk osx-cross/arm osx-cross/avr ; do
    brew tap $tap
    brew-trust --tap $tap
done

brew install --quiet qmk
