#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

## Install and configure Raycast. NOTE: You'll need an API key for the AI stuff.
brew-install-cask raycast

echo "Set up Raycast according to your preferences."
add-login-item Raycast

# Set the hotkey to Control+Option+Command+Space.
defaults write com.raycast.macos raycastGlobalHotkey "Control-Option-Command-49"

open-app Raycast


# My settings (MANUAL):
#
# General
#   ENABLE Launch Raycast at login
#   Raycast hotkey: Control-Option-Command-Space
#     NOTE: I have Karabiner map 2 × Left Shift to this
# Advanced
#   Show Raycast on: Screen with active window
# Extensions
#   Visual Studio Code
#     ENABLE Commands
