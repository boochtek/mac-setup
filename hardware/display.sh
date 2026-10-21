#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/privacy.sh"
require-full-disk-access

# Cache the sudo password.
echo "$(tput setaf 4)You may be prompted for your sudo password.$(tput sgr0)"
# Pre-authorize sudo. Skip the prompt when sudo is already passwordless, so
# unattended runs (such as the VM test harness over SSH) do not fail here.
sudo -n true 2>/dev/null || sudo -v

# Enable zooming the display.
# System Settings -> Accessibility -> Zoom -> Use scroll gesture with modifier keys to zoom
sudo defaults write com.apple.UniversalAccess closeViewScrollWheelToggle -bool TRUE

# Zoom the display when holding Control and scrolling up with 2 fingers or scroll wheel.
defaults write com.apple.UniversalAccess HIDScrollZoomModifierMask -int 262144

# When zooming the display, follow the keyboard focus.
# System Settings -> Accessibility -> Zoom -> Zoom follows the keyboard focus
sudo defaults write com.apple.UniversalAccess closeViewZoomFollowsFocus -bool TRUE
