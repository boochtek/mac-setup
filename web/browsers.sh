#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

## Install and configure web browsers.

# We'll use [Finicky](https://github.com/johnste/finicky) to use different browsers for different sites and web apps.
# Alternatives: [Choosy](https://www.choosyosx.com/), Browser Fairy, Browserosaurus, OpenIn, Browser ChooserX
brew-install-cask finicky
# WARNING: You'll be prompted to change your default browser to Finicky. Click **Use "Finicky"**.
open -a Finicky

# TODO: Make sure Finicky starts at login.
#   Manual: System Settings / General / Login Items / + `/Applications/Finicky.app`

# NOTE: Google Chrome and its extensions are installed by ./chrome.sh.

# Install Microsoft Edge.
# NOTE: You'll be prompted for your password.
echo 'Installing Microsoft Edge... You may be prompted for your password.'
brew-install-cask microsoft-edge
dockutil --add '/Applications/Microsoft Edge.app' --replacing 'Microsoft Edge' --after 'Safari'

# Install Firefox browser.
brew-install-cask firefox
dockutil --add '/Applications/Firefox.app' --replacing 'Firefox' --after 'Microsoft Edge'
# NOTE: Firefox extensions and preferences (bookmarks toolbar, vertical tabs, 1Password, etc.)
#       are configured by ./firefox.sh via Enterprise Policies.

# Install Firefox Developer Edition.
brew-install-cask firefox@developer-edition
dockutil --add '/Applications/Firefox Developer Edition.app' --replacing 'Firefox Developer Edition' --after 'Firefox'

# Create a folder for extra browsers, add it to the Dock.
mkdir -p /Applications/Browsers
ln -s '/Applications/Google Chrome.app' '/Applications/Browsers/Google Chrome.app'
ln -s '/Applications/Microsoft Edge.app' '/Applications/Browsers/Microsoft Edge.app'
ln -s '/Applications/Safari.app' '/Applications/Browsers/Safari.app'
ln -s '/Applications/Firefox.app' '/Applications/Browsers/Firefox.app'
ln -s '/Applications/Firefox Developer Edition.app' '/Applications/Browsers/Firefox Developer Edition.app'
dockutil --add '/Applications/Browsers' --replacing 'Browsers' --after 'Google Chrome' --display folder --view grid --sort name &>/dev/null
# NOTE: Due to OS limitation, dockutil `--view grid` only works if adding to `--section others`.
# TODO: AUTOMATE: Give the folder a nice icon. See https://apple.stackexchange.com/questions/20262/how-can-i-specify-a-custom-icon-for-a-dock-stack.
#   Created a folder with the desired icon, using https://folderart.christianvm.dev/ and the Font Awesome icon for "globe" (classic regular).
#   Followed these instructions to set the folder icon: https://support.apple.com/en-au/guide/mac-help/mchlp2313/mac.
#   Also consider https://macosicons.com/, https://github.com/kfreitag1/FancyFolders, and https://thisdevbrain.com/how-to-create-a-custom-macos-folder-icon/.

# Terminal-based web browsers.
brew install --quiet lynx
brew install --quiet links
brew install --quiet w3m
