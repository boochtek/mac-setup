#!/bin/bash

# TODO: Probably rename this `misc/menu.sh` or `misc/menubar.sh`.
# NOTE: Paletro costs $6.99. Details in the app and on their site.
# Or you can get it through Setapp. Either way should work.

# Variant of the unofficial Bash strict mode.
set -Euo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"
[[ -n "${DEBUG+unset}" ]] && set -x

# Install [Paletro](https://appmakes.io/paletro)
brew-install-cask paletro

# Interactive!
echo "Paletro installed. Opening..."
echo "Press the 'Open System Settings' button in the pop-up window."
echo "That will open System Settings / Privacy & Security / Accessibility"
echo "Turn Paletro to the ON position."
echo "Authenticate to the pop-up to authorize Paletro to have control of your computer."
echo "Hit the 'Quick Setup' button in the Paletro welcome window."
echo "Finish the dialog."
echo "See misc/Paletro-Accessibility-Access-request-dialog.png"
open-app Paletro &
echo "Press Enter to continue..."
read -r
# NOTE: I think I had to run it a 2nd time.

# Set it to start at login.
defaults write io.appmakes.Paletro startOnLogin -bool TRUE
defaults write io.appmakes.Paletro-setapp startOnLogin -bool TRUE

# Disable Paletro in apps that have their own Cmd+Shift+P command palette, so the
# universal palette chord (K1 Pro QMK F2 / Karabiner double-right-shift -> Cmd+Shift+P)
# triggers each app's native palette instead of Paletro. Apps not listed default
# to "allow". See the Keychron K1 Pro QMK PRD, "App-specific palette bindings".
# NOTE: Quit Paletro first (or relaunch after) so it picks up the change.
PALETTE_EXCLUSIONS='( ( "com.microsoft.VSCode", disabled, "VS Code" ), ( "com.sublimetext.2", disabled, "Sublime Text" ), ( "com.github.atom", disabled, Atom ), ( "md.obsidian", disabled, Obsidian ), ( "com.googlecode.iterm2", disabled, iTerm ) )'
defaults write io.appmakes.Paletro palette_rule_app "$PALETTE_EXCLUSIONS"
defaults write io.appmakes.Paletro-setapp palette_rule_app "$PALETTE_EXCLUSIONS"

# KeyClu: Hit `Command ⌘` twice and hold to list all shortcuts in any app.
# Shortcuts are listed by the menu items they are associated with.
brew uninstall --quiet --cask keyclu
open-app KeyClu
defaults write com.0804Team.KeyClu launchAtLogin -bool TRUE
