#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

## Install and configure Thunderbird email client.



# Install Thunderbird email client.
brew-install-cask thunderbird

# Add an icon to the Dock.
dockutil --add  '/Applications/Thunderbird.app' --replacing 'Thunderbird' --after Calendar
