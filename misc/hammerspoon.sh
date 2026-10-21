#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

# Install Hammerspoon
brew-install-cask hammerspoon
open-app Hammerspoon
echo "TODO: enable Hammerspoon in System Settings > Privacy & Security > Accessibility"
