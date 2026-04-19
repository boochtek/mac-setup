#!/bin/bash

# Install ble.sh, the Bash Line Editor (like ZLE). Adds syntax highlighting, auto-completion, and more.
#brew install --quiet ble.sh


# Install Atuin, a modern shell history manager with search and sync.
brew install --quiet atuin
brew services start atuin

# Atuin Desktop is for executable runbooks using Atuin, with variable substitution and templating.
brew install --quiet --cask atuin-desktop
