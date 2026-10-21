#!/bin/bash

# NOTE: Setapp costs $9.99/month.
# I pay $14.99 for the Power User plan, so I can run it on 4 Macs and 4 iOS devices.

# Variant of the unofficial Bash strict mode.
set -Euo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR
[[ -n "${DEBUG+unset}" ]] && set -x

source "${BASH_SOURCE%/*}/../util/apps.sh"

# Install [Setapp](https://setapp.com/).
brew-install-cask setapp

# Interactive!
echo "Setapp installed. Opening..."
open-app Setapp &
echo 'Click on the Setapp icon in the menu bar.'
echo 'Add apps in the Setapp UI. They will appear in the Applications/Setapp folder.'
add-login-item Setapp

# WARNING: I've had 2 copies of Paletro and BetterTouchTool - from Setapp and from the vendors.

echo "Install and configure Supercharge:"
