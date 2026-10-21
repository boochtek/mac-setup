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
# so Gatekeeper still checks them on first launch. Only handles `app` artifacts.
# Changing an app requires the terminal to have App Management permission.
unquarantine-casks() {
    local app app_path
    brew info --cask --json=v2 "$@" |
        jq -r '.casks[] | select(.tap == "homebrew/cask") | .artifacts[] | .app // empty | .[1].target? // .[0]' |
        while IFS= read -r app; do
            app_path="$(app-path "$app")"
            if xattr -p com.apple.quarantine "$app_path" &>/dev/null; then
                # Helper apps inside the bundle are quarantined too.
                xattr -dr com.apple.quarantine "$app_path" 2>/dev/null ||
                    echo "WARNING: Could not unquarantine $app. Give this terminal App Management permission." >&2
            fi
        done
}

# The path of an app, given its name (in /Applications) or its path.
app-path() {
    if [[ "$1" == /* ]]; then
        echo "$1"
    else
        echo "/Applications/${1%.app}.app"
    fi
}

# Open an app by its path, with any `open` options after its name or path.
# Opening by name (`open -a Name`) fails right after installing the app,
# because LaunchServices hasn't registered it yet.
open-app() {
    local app_path
    app_path="$(app-path "$1")"
    shift
    open "$@" "$app_path"
}

# Start an app at login, unless it already does. Takes the app's name or path,
# optionally preceded by `--hidden` to start it hidden.
add-login-item() {
    local hidden=false app_path name
    if [[ "$1" == --hidden ]]; then
        hidden=true
        shift
    fi
    app_path="$(app-path "$1")"
    name="$(basename "$app_path" .app)"
    osascript -e "tell application \"System Events\" to if not (exists login item \"$name\") then make login item at end with properties {path:\"$app_path\", hidden:$hidden}" >/dev/null
}
