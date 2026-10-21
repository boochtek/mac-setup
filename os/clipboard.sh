#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

# DID NOT LIKE: Use Maccy clipboard manager.
# brew install --quiet --cask maccy
# open -a Maccy

# DID NOT LIKE: Collective (App Store). Its window looked wrong at my font size,
# opened on the wrong screen, and hit 100% CPU / hung on startup.

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
