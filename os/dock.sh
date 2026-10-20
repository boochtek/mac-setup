#!/bin/bash

# Enable strict mode + error trap only when run directly, not when sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set -Euo pipefail
    IFS=$'\n\t'
    [[ -n "${DEBUG+unset}" ]] && set -x
    trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR
fi

# NOTE: Adding apps to the Dock should happen in the scripts where said apps are installed.

## Disable animations when opening an application from the Dock.
defaults write com.apple.dock launchanim -bool FALSE

## Automatically hide and show the Dock.
defaults write com.apple.dock autohide -bool TRUE

## Eliminate any delay before showing the Dock.
defaults write com.apple.Dock autohide-delay -float 0

# We use dockutil to add and remove icons in the Mac OS X dock.
## Install dockutil
brew install --quiet dockutil

## Remove rarely-used Dock items.
for dock_item in Apps Launchpad Contacts Notes Reminders Maps Messages FaceTime iBooks Podcasts TV News Games Freeform Keynote Numbers Pages Phone ; do
    dockutil --remove "$dock_item" &> /dev/null || true
done
dockutil --remove 'App Store' &> /dev/null || true

## Add Activity Monitor to the Dock.
dockutil --find "Activity Monitor" &> /dev/null \
    || dockutil --add "/System/Applications/Utilities/Activity Monitor.app" --position end

## Show CPU graph in Activity Monitor icon in Dock.
defaults write com.apple.ActivityMonitor IconType -int 6

## Show hidden apps in Dock, with dimmed icons.
defaults write com.apple.Dock showhidden -bool TRUE

## Restart the Dock.
killall Dock
