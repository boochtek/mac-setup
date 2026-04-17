#!/bin/bash

source "${BASH_SOURCE%/*}/../os/dock.sh"

# Install iTerm2.
brew install --quiet --cask iterm2

# Download shell integration. Shell startup scripts should source the appropriate script.
ITERM_SHELL_INTEGRATION="${ITERM_SHELL_INTEGRATION-$XDG_DATA_HOME/iterm2}"
mkdir -p "$ITERM_SHELL_INTEGRATION"
for shell in bash zsh fish tcsh ; do
    wget "https://iterm2.com/shell_integration/$shell" -O "$ITERM_SHELL_INTEGRATION/iterm2_shell_integration.$shell"
done

# Add iTerm2 to the Dock. Allow time for it to get added before opening the app.
dockutil --add  '/Applications/iTerm.app' --replacing 'iTerm' --after 'Photos' &> /dev/null
sleep 2

# Open iTerm2.
open -a /Applications/iTerm.app
