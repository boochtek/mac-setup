#!/bin/bash

## Configure Twitter.

## NOTE: The Twitter app is installed via the Mac App Store.
## NOTE: We don't use Twitter very much, since it became X.

# Disable smart quotes as it’s annoying for tweets with code snippets.
defaults write com.twitter.twitter-mac AutomaticQuoteSubstitutionEnabled -bool false

# Show the app window when clicking the menu bar icon.
defaults write com.twitter.twitter-mac MenuItemBehavior -int 1

# Enable the hidden 'Develop' menu.
defaults write com.twitter.twitter-mac ShowDevelopMenu -bool true

# Enable the hidden 'Secret' preferences tab.
defaults write com.twitter.twitter-mac DebugMode -bool true

# Open links in the background.
defaults write com.twitter.twitter-mac openLinksInBackground -bool true

# Allow closing the 'New Tweet' window by pressing Escape.
defaults write com.twitter.twitter-mac ESCClosesComposeWindow -bool true

# Show full names rather than Twitter handles.
defaults write com.twitter.twitter-mac ShowFullNames -bool true

# Hide the app in the background if it's not the front-most window.
defaults write com.twitter.twitter-mac HideInBackground -bool true
