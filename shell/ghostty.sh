#!/bin/bash

source "${BASH_SOURCE%/*}/../os/dock.sh"

# Install Ghostty.
brew install --quiet --cask --no-quarantine ghostty

# Add Ghostty to the Dock. Allow time for it to get added before opening the app.
dockutil --add  '/Applications/Ghostty.app' --replacing 'Ghostty' --after 'iTerm' &> /dev/null
sleep 2

# Open Ghostty.
open -a /Applications/Ghostty.app
