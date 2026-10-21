#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

# Show Debug menu in App Store app.
defaults write com.apple.appstore 'ShowDebugMenu' -bool TRUE

## Install MAS (Mac App Store CLI) utility and apps that have been installed through App Store.
## NOTE: You may be prompted (via GUI) to sign into the Mac App Store.

# Install MAS.
brew install mas

# Install Bear note-taking app. Start it at login and now.
app-store-install 1091189122 Bear # Bear: Markdown Notes
add-login-item Bear
open-app --background Bear

# Install Firetask task-tracking app. Start it at login and now.
# Its app name may include its major version, like the App Store's "Firetask 5".
FIRETASK_APPS='/Applications/Firetask*.app'
compgen -G "$FIRETASK_APPS" >/dev/null || mas get 6480322972 # Firetask 5
firetask_app="$(compgen -G "$FIRETASK_APPS" | head -1)"
add-login-item --hidden "$firetask_app"
open-app --background "$firetask_app"

# TODO: More apps from the App Store.
# TODO: What else should we auto-start?
# TODO: Add items to Dock, as appropriate. (Make sure we've installed dockutils before this gets run.)

# Update all App Store apps.
mas upgrade