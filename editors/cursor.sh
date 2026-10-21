#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

## Install and configure Cursor. NOTE: You'll need an API key.
brew-install-cask cursor
open-app Cursor

dockutil --add '/Applications/Cursor.app' --replacing 'Cursor' --after 'Zed' &>/dev/null
brew install --quiet cursor-cli

# Install and configure Void. NOTE: You'll need an API key.
brew-install-cask void
dockutil --add '/Applications/Void.app' --replacing 'Void' --after 'Windsurf' &>/dev/null
