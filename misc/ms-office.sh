#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

## Microsoft Office

# NOTE: There's a `microsoft-office` cask, but I don't want to install all the apps.

# Dependencies / nice-to-have.
brew-install-cask microsoft-auto-update
brew trust --cask niksy/pljoska/font-microsoft-cleartype-family
brew install --quiet niksy/pljoska/font-microsoft-cleartype-family

# Install individual Office apps.
brew-install-cask microsoft-word
brew-install-cask microsoft-excel
# brew-install-cask microsoft-powerpoint
# brew-install-cask microsoft-outlook
# brew-install-cask microsoft-remote-desktop
# brew-install-cask onedrive

# Add to Dock.
dockutil --add '/Applications/Microsoft Word.app' --replacing 'Microsoft Word' --after 'Obsidian' &>/dev/null
dockutil --add '/Applications/Microsoft Excel.app' --replacing 'Microsoft Excel' --after 'Microsoft Word' &>/dev/null
# dockutil --add  '/Applications/Microsoft PowerPoint.app' --replacing 'Microsoft PowerPoint' --after 'Microsoft Excel' &> /dev/null
# dockutil --add  '/Applications/Microsoft Outlook.app' --replacing 'Microsoft Outlook' --after 'Mail' &> /dev/null
# dockutil --add  '/Applications/Microsoft Remote Desktop.app' --replacing 'Microsoft Remote Desktop' --after 'iTerm' &> /dev/null
# dockutil --add  '/Applications/OneDrive.app' --replacing 'OneDrive' --after 'Microsoft Remote Desktop' &> /dev/null
