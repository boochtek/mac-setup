#!/bin/bash

## Apps used specifically for DebtBook

# Variant of the unofficial Bash strict mode.
set -uo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR
[[ -n "${DEBUG+unset}" ]] && set -x


brew install --quiet --cask slack

dockutil --add '/Applications/Slack.app' --replacing 'Slack' --position beginning &> /dev/null

mkdir -p /Applications/Browsers
ln -s '/Applications/Google Chrome.app' '/Applications/Browsers/Google Chrome.app'
ln -s '/Applications/Chromium.app' '/Applications/Browsers/Chromium.app'
ln -s '/Applications/Vivaldi.app' '/Applications/Browsers/Vivaldi.app'
ln -s '/Applications/Arc.app' '/Applications/Browsers/Arc.app'
ln -s '/Applications/Microsoft Edge.app' '/Applications/Browsers/Microsoft Edge.app'
ln -s '/Applications/Safari.app' '/Applications/Browsers/Safari.app'
ln -s '/Applications/Firefox Developer Edition.app' '/Applications/Browsers/Firefox Developer Edition.app'

dockutil --add '/Applications/Browsers' --replacing 'Browsers' --after 'Google Chrome' &> /dev/null
