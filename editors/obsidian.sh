#!/bin/bash

## Install and configure Obsidian.
brew install --quiet --cask obsidian

dockutil --add  '/Applications/Obsidian.app' --replacing 'Obsidian' --after 'Visual Studio Code' &> /dev/null
