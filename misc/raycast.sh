#!/bin/bash

## Install and configure Raycast. NOTE: You'll need an API key for the AI stuff.
brew install --quiet --cask raycast

echo "Set up Raycast according to your preferences."
echo "Set to launch at login."

# Set the hotkey to Control+Option+Command+Space.
defaults write com.raycast.macos raycastGlobalHotkey "Control-Option-Command-49"

open -a Raycast


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
