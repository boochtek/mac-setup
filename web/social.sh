#!/bin/bash

# Variant of the unofficial Bash strict mode.
set -uo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR
[[ -n "${DEBUG+unset}" ]] && set -x

# Install Slack.
brew install --quiet --cask slack
dockutil --add '/Applications/Slack.app' --replacing 'Slack' --position end

# Install Discord.
brew install --quiet --cask discord
dockutil --add '/Applications/Discord.app' --replacing 'Discord' --after 'Slack'
