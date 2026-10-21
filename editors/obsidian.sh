#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

## Install and configure Obsidian.
brew-install-cask obsidian

dockutil --add  '/Applications/Obsidian.app' --replacing 'Obsidian' --after 'Visual Studio Code' &> /dev/null
