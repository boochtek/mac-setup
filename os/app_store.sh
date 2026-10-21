#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

# Show Debug menu in App Store app.
defaults write com.apple.appstore 'ShowDebugMenu' -bool TRUE

## Install MAS (Mac App Store CLI) utility and apps that have been installed through App Store.
## NOTE: You may be prompted (via GUI) to sign into the Mac App Store.

# Install MAS.
brew install mas

# Install Bear note-taking app. Start it at login and now.
if [[ ! -e '/Applications/Bear.app' ]]; then
    mas list | grep -q 'Bear: Markdown Notes' || mas lucky 'Bear: Markdown Notes'
    osascript -e 'tell application "System Events" to make login item with properties {path:"/Applications/Bear.app", hidden:false}' >/dev/null
    open -gj -a 'Bear'
fi

# Install Firetask task-tracking app. Start it at login and now.
if [[ ! -e '/Applications/Firetask.app' ]]; then
    mas list | grep -q 'Firetask' || mas lucky 'Firetask'
    osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Firetask.app", hidden:true}' >/dev/null
    open -gj -a 'Firetask'
fi

# TODO: More apps from the App Store.
# TODO: What else should we auto-start?
# TODO: Add items to Dock, as appropriate. (Make sure we've installed dockutils before this gets run.)

# Update all App Store apps.
mas upgrade