#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

brew-install-cask rubymine

dockutil --add  '/Applications/RubyMine.app' --replacing 'RubyMine' --after 'Visual Studio Code' &> /dev/null

# TO AUTOMATE: Install plugins.
#       Key Promoter X
#       Rainbow Brackets
#       Enable rainbow variables
