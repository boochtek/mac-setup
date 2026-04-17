#!/bin/bash

## Install and configure Thunderbird email client.

source 'homebrew.sh'
source 'dockutil.sh'


# Install Thunderbird email client.
brew install --quiet --cask thunderbird

# Add an icon to the Dock.
dockutil --add  '/Applications/Thunderbird.app' --replacing 'Thunderbird' --after Calendar
