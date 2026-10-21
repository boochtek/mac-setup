#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

source "${BASH_SOURCE%/*}/../os/dock.sh"

# Install iTerm2.
brew-install-cask iterm2

# Download shell integration. Shell startup scripts should source the appropriate script.
ITERM_SHELL_INTEGRATION="${ITERM_SHELL_INTEGRATION-$XDG_DATA_HOME/iterm2}"
mkdir -p "$ITERM_SHELL_INTEGRATION"
for shell in bash zsh; do
	wget "https://iterm2.com/shell_integration/$shell" -O "$ITERM_SHELL_INTEGRATION/iterm2_shell_integration.$shell"
done

# Add iTerm2 to the Dock. Allow time for it to get added before opening the app.
dockutil --add '/Applications/iTerm.app' --replacing 'iTerm' --after 'Photos' &>/dev/null
sleep 2

# Bind Cmd+Shift+P -> "Open Quickly" (iTerm's command palette), so the universal
# palette chord (K1 Pro QMK F2 / Karabiner double-right-shift -> Cmd+Shift+P) opens
# it. A macOS App Shortcut (NSUserKeyEquivalents) REPLACES a menu item's shortcut,
# so we also clear Cmd+Shift+P off iTerm's built-in "Page Setup" (its default) --
# a zero-width space is an un-typeable, effectively-disabled shortcut (see
# hardware/keyboard.sh). @ = Command, $ = Shift.
# See the Keychron K1 Pro QMK PRD, "App-specific palette bindings".
ZERO_WIDTH_SPACE=$'\xe2\x80\x8b' # U+200B
# '@$p' is a literal App Shortcut code (@ = Command, $ = Shift), not a shell var.
# shellcheck disable=SC2016
defaults write com.googlecode.iterm2 NSUserKeyEquivalents -dict-add "Open Quickly" '@$p'
defaults write com.googlecode.iterm2 NSUserKeyEquivalents -dict-add "Page Setup…" "$ZERO_WIDTH_SPACE"

# Open iTerm2.
open-app iTerm
