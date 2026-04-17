#!/bin/bash

# TODO: Probably rename this `misc/menu.sh` or `misc/menubar.sh`.
# NOTE: Paletro costs $6.99. Details in the app and on their site.
# Or you can get it through Setapp. Either way should work.

# Variant of the unofficial Bash strict mode.
set -uo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR
[[ -n "${DEBUG+unset}" ]] && set -x


# Install [Paletro](https://appmakes.io/paletro)
brew install --quiet --cask paletro

# Interactive!
echo "Paletro installed. Opening..."
echo "Press the 'Open System Settings' button in the pop-up window."
echo "That will open System Settings / Privacy & Security / Accessibility"
echo "Turn Paletro to the ON position."
echo "Authenticate to the pop-up to authorize Paletro to have control of your computer."
echo "Hit the 'Quick Setup' button in the Paletro welcome window."
echo "Finish the dialog."
echo "See `misc/Paletro-Accessibility-Access-request-dialog.png`"
open -a Paletro &
echo "Press Enter to continue..."
read -r
# NOTE: I think I had to run it a 2nd time.

# Set it to start at login.
defaults write io.appmakes.Paletro startOnLogin -bool TRUE
defaults write io.appmakes.Paletro-setapp startOnLogin -bool TRUE

# KeyClu: Hit `Command ⌘` twice and hold to list all shortcuts in any app.
# Shortcuts are listed by the menu items they are associated with.
brew uninstall --quiet --cask keyclu
open -a KeyClu
defaults write com.0804Team.KeyClu launchAtLogin -bool TRUE
