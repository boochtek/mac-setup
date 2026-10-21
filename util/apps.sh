#!/bin/bash

## Helper functions for installing apps.

# Install casks, then clear the quarantine flag on their apps, so macOS doesn't ask
# "... is an app downloaded from the Internet. Are you sure you want to open it?"
brew-install-cask() {
    brew install --quiet --cask "$@"
    unquarantine-casks "$@"
}

# Clear the quarantine flag on the apps that official Homebrew casks installed.
# (Homebrew 7 removed `--no-quarantine`.) Apps from third-party taps keep the flag,
# so Gatekeeper still checks them on first launch.
# Changing an app requires the terminal to have App Management permission.
unquarantine-casks() {
    local app
    brew info --cask --json=v2 "$@" |
        jq -r '.casks[] | select(.tap == "homebrew/cask") | .artifacts[] | .app // empty | .[1].target? // .[0]' |
        while IFS= read -r app; do
            if xattr -p com.apple.quarantine "/Applications/$app" &>/dev/null; then
                xattr -d com.apple.quarantine "/Applications/$app" ||
                    echo "WARNING: Could not unquarantine $app. Give this terminal App Management permission." >&2
            fi
        done
}

# Open an app by its path, with any `open` options after its name.
# Opening by name (`open -a Name`) fails right after installing the app,
# because LaunchServices hasn't registered it yet.
open-app() {
    local app="$1"
    shift
    open "$@" "/Applications/${app%.app}.app"
}
