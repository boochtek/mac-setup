#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"
source "${BASH_SOURCE%/*}/../util/privacy.sh"

# Install Ghostty.
brew-install-cask ghostty

# Add Ghostty to the Dock. Allow time for it to get added before opening the app.
dockutil --add  '/Applications/Ghostty.app' --replacing 'Ghostty' --after 'iTerm' &> /dev/null
sleep 2

# Make sure config directory exists. See https://ghostty.org/docs/config for full details.
mkdir -p ~/.config/ghostty

# Make sure we have the xterm-ghostty terminfo entry.
if ! infocmp -1 xterm-ghostty &> /dev/null; then
    # Make sure $TERMINFO is set to a directory we have write access to.
    if [[ -z "${TERMINFO}" || ! -w "${TERMINFO}" ]]; then
        export TERMINFO="$HOME/.terminfo"
    fi

    mkdir -p $TERMINFO/78
    cp "/Applications/Ghostty.app/Contents/Resources/terminfo/78/xterm-ghostty" "$TERMINFO/78/xterm-ghostty"
fi

# Open Ghostty.
open-app Ghostty

# Setup scripts change settings and apps that macOS protects.
explain-terminal-permissions Ghostty
