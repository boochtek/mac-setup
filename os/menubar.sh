#!/bin/bash

set -uo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR

## Configure system menu bar the way we want it.

## Disable transparency in the menu bar. NOTE: Big Sur (macOS 11) seems to have dropped support for this.
defaults write -g AppleEnableMenuBarTransparency -bool FALSE

# Clock - display day of week, 12-hour time (but no AM/PM) digital clock with a non-flashing separator.
# System Preferences > Date & Time > Clock
# Time options: Digital
defaults write com.apple.menuextra.clock IsAnalog -bool FALSE

# System Preferences > Date & Time > Clock
# Time options: Display the time with seconds: off
# Date options: Show the day of the week: on
# Date options: Show date: always
defaults write com.apple.menuextra.clock DateFormat "EEE MMM d  h:mm"

# Battery - show percentage charged. NOTE: Does not seem to work in MacOS Monterey.
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# TODO: Remove from menu bar - User (is that a default? any others?) (but leave on for Beth's laptop)

# TODO: Disable Notification Center. Try http://www.defaults-write.com/disable-notification-center-in-mac-os-x-mountain-lion/#.U32cGpRdXag

# TODO: In Keyboard preferences, Keyboard pane, CHECK “Show Keyboard & Character Viewers in menu bar”.

## Allow MenuBar and menuextra changes to take effect.
killall SystemUIServer

# # TopNotch turns the menu bar black to hide the notch on MacBook Pros.
# # TopNotch no longer works for me.
# brew install --quiet --cask topnotch
# defaults write pl.maketheweb.TopNotch hideOnBuiltInOnly -bool TRUE
# defaults write pl.maketheweb.TopNotch isEnabled -bool TRUE
# defaults write pl.maketheweb.TopNotch SUEnableAutomaticChecks -bool TRUE
# defaults write pl.maketheweb.TopNotch lastAcceptedEulaVersion 1
# defaults write pl.maketheweb.TopNotch hideMenubarIcon -bool TRUE
# open -a TopNotch

# Forehead is a TopNotch alternative, making the menubar black.
echo "MANUAL: Download and install Forehead, then enable it "

# Trying Hidden Bar as a replacement for Bartender and Ice.
brew install --quiet --cask hiddenbar
open -a 'Hidden Bar'
