#!/bin/bash

# Don't bother with the "desktop" behind all our windows. From http://lifehacker.com/hide-and-show-desktop-icons-on-os-x-with-an-automator-s-5704241
defaults write com.apple.finder CreateDesktop -bool false

# Don't show any special icons on desktop. (These shouldn't really matter when we're already hiding the desktop.)
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

# Set "wallpaper" for the desktop background.
mkdir -p "$HOME/Pictures/Backgrounds"
# TODO: Find this wallpaper image again, or a suitable replacement.
# wget --directory-prefix=~/Pictures/Backgrounds http://pic.1fotonin.com//data/wallpapers/20/WDF_683106.jpg
# wallpaper set "~/Pictures/Backgrounds/WDF_683106.jpg"

# Restart Finder so settings will take effect.
killall Finder


# Install Rectangle window manager.
brew install --cask --quiet rectangle
echo "TODO: Automate: System Settings > Privacy & Security > Accessibility > ENABLE Rectangle"
open -a Rectangle
echo "TODO: Automate: Rectangle (in menu bar) Settings > ENABLE Launch on login"
echo "TODO: Automate: Rectangle (in menu bar) Settings > ENABLE Check for updates automatically"
