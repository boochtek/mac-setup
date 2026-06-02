#!/bin/bash

set -uo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR

## Install and configure Cursor. NOTE: You'll need an API key.
brew install --quiet --cask cursor
open -a Cursor

dockutil --add '/Applications/Cursor.app' --replacing 'Cursor' --after 'Zed' &>/dev/null
brew install --quiet cursor-cli

# Install and configure Void. NOTE: You'll need an API key.
brew install --quiet --cask void
dockutil --add '/Applications/Void.app' --replacing 'Void' --after 'Windsurf' &>/dev/null
