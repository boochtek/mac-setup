#!/bin/bash

## Install and configure Sublime Text.

## NOTE: Most configuration will happen in user-specific config files.


source 'homebrew.sh'
source 'dockutil.sh'


# Install Sublime Text 3
brew install --quiet --cask sublime-text3

# The Homebrew installation provides a binary named `subl`. We'll provide a couple other names for that.
ln -s subl /usr/local/bin/sublime
ln -s subl /usr/local/bin/sublime-text

# Load the Package Control package manually.
curl -o "$HOME/Library/Application Support/Sublime Text 3/Installed Packages/Package Control.sublime-package" https://sublime.wbond.net/Package%20Control.sublime-package

# We'll maintain all our Sublime Text settings in our config_files repository.
# NOTE: This includes the list of packages we have installed. Package Control will load any missing packages when Sublime Text starts up.
ln -sf ~/config_files/sublime/* "$HOME/Library/Application Support/Sublime Text 3/Packages/User/"


# TODO: Include a better code font:
#			http://www.google.com/fonts/specimen/Cousine

# TODO: More packages:
#   SublimeLinter-ruby or SublimeLinter-rubocop


# Install `enscript`, so the Simple Print Function plugin will work.
brew install enscript

# Install `ctags`, so the CTags plugin will work.
brew install ctags

# Add an icon to the Dock.
dockutil --add  '~/Applications/Sublime Text.app' --replacing 'Sublime Text'
