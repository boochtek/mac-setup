#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/privacy.sh"
require-full-disk-access

## Configure trackpad.

# NOTE: You'll need to log out and back in for some of these (like tap-to-click) to work.

# Cache the sudo password.
echo "$(tput setaf 4)You may be prompted for your sudo password.$(tput sgr0)"
# Pre-authorize sudo. Skip the prompt when sudo is already passwordless, so
# unattended runs (such as the VM test harness over SSH) do not fail here.
sudo -n true 2>/dev/null || sudo -v

# Enable tap to click. (Don't have to press down on the trackpad -- just tap it.)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool TRUE
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool TRUE
# Enable tap to click for the login screen, and update prefpane. (May or may not work in Mavericks.)
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable "tap-and-a-half" to drag.
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -int 1
defaults write com.apple.AppleMultitouchTrackpad Dragging -int 1

# Enable 3-finger drag. (Moving with 3 fingers in any window "chrome" moves the window.)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool TRUE
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool TRUE

# Enable scroll-to-zoom with Ctrl (^) modifier key (and 2 fingers).
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool TRUE
defaults write com.apple.universalaccess closeViewScrollWheelModifiersInt -int 262144
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad HIDScrollZoomModifierMask -int 262144
defaults write com.apple.AppleMultitouchTrackpad HIDScrollZoomModifierMask -int 262144

# Ensure trackpad scrolls in the "natural" direction.
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool TRUE
