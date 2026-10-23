# This file is sourced. Tell shellcheck it's Bash:
# shellcheck shell=bash

## Helper functions for installing apps.

# Install casks without macOS's "downloaded from the Internet" prompt on first open.
brew-install-cask() {
    brew install --quiet --cask "$@"
    unquarantine-cask-apps "$@"
}

# Only for official casks; Gatekeeper still checks apps from third-party taps.
# (Homebrew 7 removed `--no-quarantine`.)
unquarantine-cask-apps() {
    local app
    official-cask-apps "$@" | while IFS= read -r app; do
        unquarantine-app "$app"
    done
}

# Names of the apps that official casks install. An `app` artifact is ["Foo.app"],
# or ["Foo.app", {"target": "Bar.app"}] when the cask renames the app. Without a
# target, an app in a subfolder ("Folder/Foo.app") is installed as "Foo.app".
official-cask-apps() {
    brew info --cask --json=v2 "$@" |
        jq -r '.casks[] | select(.tap == "homebrew/cask") | .artifacts[] | .app // empty | .[1].target? // (.[0] | split("/") | last)'
}

unquarantine-app() {
    local app_path
    app_path="$(app-path "$1")"
    xattr -p com.apple.quarantine "$app_path" &>/dev/null || return 0
    # Recursive, because helper apps inside the bundle are quarantined too.
    # -s: change symlinks themselves, not what they point to.
    xattr -drs com.apple.quarantine "$app_path" 2>/dev/null ||
        echo "WARNING: Could not unquarantine $1. Give this terminal App Management permission." >&2
}

# Trust a third-party `--tap`, `--formula`, or `--cask`, unless it already is.
# (`brew trust` otherwise prints "Already trusted", even with `--quiet`.)
brew-trust() {
    local kind="$1" name="${2:-}" list
    case "$kind" in
        --tap) list=taps ;;
        --formula) list=formulae ;;
        --cask) list=casks ;;
        *) echo "brew-trust: expected --tap, --formula, or --cask, not '$kind'" >&2; return 2 ;;
    esac
    brew trust --json=v1 | jq -e --arg list "$list" --arg name "$name" '.[$list] | index($name) != null' >/dev/null ||
        brew trust "$kind" "$name"
}

# Install an App Store app by its ID, unless it's installed. Unlike `mas install`
# (and `mas lucky`), `mas get` also gets free apps this Apple ID hasn't gotten.
# IDs avoid ambiguous matches when searching by name.
app-store-install() {
    local id="$1" app="$2"
    [[ -e "$(app-path "$app")" ]] || mas get "$id"
}

# The path of an app, given its name (in /Applications) or its path.
app-path() {
    if [[ "$1" == /* ]]; then
        echo "$1"
    else
        echo "/Applications/${1%.app}.app"
    fi
}

# Open an app by its path, optionally `--background` (without bringing it forward).
# (`open -a Name` fails right after installing the app; LaunchServices hasn't registered it yet.)
open-app() {
    if [[ "$1" == --background ]]; then
        open -g -j "$(app-path "$2")"
    else
        open "$(app-path "$1")"
    fi
}

# Start an app at login, unless it already does. Optionally `--hidden`.
add-login-item() {
    local hidden=false app_path
    if [[ "$1" == --hidden ]]; then
        hidden=true
        shift
    fi
    app_path="$(app-path "$1")"
    osascript - "$(basename "$app_path" .app)" "$app_path" "$hidden" >/dev/null <<'APPLESCRIPT'
on run {itemName, itemPath, isHidden}
    tell application "System Events"
        if not (exists login item itemName) then
            make login item at end with properties {path:itemPath, hidden:(isHidden is "true")}
        end if
    end tell
end run
APPLESCRIPT
}
