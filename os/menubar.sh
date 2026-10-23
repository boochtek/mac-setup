#!/bin/bash

## Configure system menu bar the way we want it.

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

# Install Hidden Bar to hide some items in the menu bar.
brew-install-cask hiddenbar
add-login-item 'Hidden Bar'
open-app 'Hidden Bar'

# Disable transparency in the menu bar. NOTE: Big Sur (macOS 11) seems to have dropped support for this.
defaults write -g AppleEnableMenuBarTransparency -bool FALSE

# Clock - display day of week, 12-hour time (but no AM/PM) digital clock with a non-flashing separator.
# System Settings > Date & Time > Clock
# Time options: Digital
defaults write com.apple.menuextra.clock IsAnalog -bool FALSE

# System Settings > Date & Time > Clock
# Time options: Display the time with seconds: off
# Date options: Show the day of the week: on
# Date options: Show date: always
defaults write com.apple.menuextra.clock DateFormat "EEE MMM d  h:mm"

# Battery - show percentage charged. NOTE: Does not seem to work in MacOS Monterey.
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# TODO: Remove from menu bar - User (is that a default? any others?) (but leave on for Beth's laptop)

# TODO: Disable Notification Center. Try http://www.defaults-write.com/disable-notification-center-in-mac-os-x-mountain-lion/#.U32cGpRdXag

# TODO: In Keyboard preferences, Keyboard pane, CHECK “Show Keyboard & Character Viewers in menu bar”.

# Disable auto-adding icons to menu items. (They're terrible inconsistent UX.)
defaults write NSGlobalDomain NSMenuEnableActionImages -bool false

## Allow MenuBar and menuextra changes to take effect.
killall SystemUIServer 2>/dev/null || true # It may not be running (yet).

# The menu bar is made black via a black-topped wallpaper (hides the notch without
# a background app); see desktop.sh.
