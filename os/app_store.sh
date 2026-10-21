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

# Install apps by their App Store IDs. Unlike `mas install` (and `mas lucky`),
# `mas get` also installs free apps that this Apple ID hasn't gotten before.

# Install Bear note-taking app. Start it at login and now.
if [[ ! -e '/Applications/Bear.app' ]]; then
    mas get 1091189122 # Bear: Markdown Notes
    add-login-item Bear
    open-app Bear -g -j # In the background, without bringing it forward.
fi

# Install Firetask task-tracking app. Start it at login and now.
# (The app's name may include its major version, like the App Store's "Firetask 5".)
if ! compgen -G '/Applications/Firetask*.app' >/dev/null; then
    mas get 6480322972 # Firetask 5
    firetask_app="$(compgen -G '/Applications/Firetask*.app' | head -1)"
    add-login-item --hidden "$firetask_app"
    open-app "$firetask_app" -g -j
fi

# TODO: More apps from the App Store.
# TODO: What else should we auto-start?
# TODO: Add items to Dock, as appropriate. (Make sure we've installed dockutils before this gets run.)

# Update all App Store apps.
mas upgrade