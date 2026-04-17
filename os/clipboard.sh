#!/bin/bash

set -uo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR

# DID NOT LIKE: Use Maccy clipboard manager.
# brew install --quiet --cask maccy
# open -a Maccy


# I mostly like Collective, but its window looks crappy with my font size, and it doesn't show up on the right screen.
# Also, it's hitting 100% CPU and hanging on startup. Then it has problems showing up on after I move it.
# Install Collective clipboard manager. Start it at login and now.
if [[ ! -e '/Applications/Collective.app' ]]; then
    mas list | grep -q 'Collective' || mas lucky 'Collective'
    osascript -e 'tell application "System Events" to make login item with properties {path:"/Applications/Collective.app", hidden:true}' >/dev/null
    open -a Collective
fi

# MANUAL configuration: Preferences.
#   General
#       Hotkey: Shift+Command+V
#       CHECK Launch at Login
#       CHECK Check for updates automatically
#       CHECK Fuzzy search


# DID NOT LIKE THAT MUCH: Install PopClip. NOTE: This is a paid app ($17) that can also be found on the App Store.
# brew install --quiet --cask popclip
# open -a PopClip
# Manual configuration.
#   Click on the icon in the Toolbar
#   Click on Enable PopClip
#   A popup will ask to enable Accesibility in System Settings; click on Open
#       Enable PopClip
#   CHECK Start at login
#   Go to https://pilotmoon.com/popclip/extensions/ and download/open extensions
#       Coding Cases
#       Uppercase, Lowercase, Capitalize Words, Title Case, Sentence Case
#       Wikipedia
#       Bear
#       Google Maps
#       Character Count, Word Count, Line Count
#       TODO: Readwise
#       TODO: Pocket
#       TODO: Randrop.io
#       TODO: Buffer
#       TODO: write extension for Onyx
#   TODO: Set up a keystroke instead of every time text is selected.
