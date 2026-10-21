#!/bin/bash

# Variant of the unofficial Bash strict mode.
set -Euo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"
[[ -n "${DEBUG+unset}" ]] && set -x

# Install Slack.
brew-install-cask slack
dockutil --add '/Applications/Slack.app' --replacing 'Slack' --position end

# Install Discord.
brew-install-cask discord
dockutil --add '/Applications/Discord.app' --replacing 'Discord' --after 'Slack'
