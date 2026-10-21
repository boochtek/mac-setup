#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

# Don't bother with the "desktop" behind all our windows. From http://lifehacker.com/hide-and-show-desktop-icons-on-os-x-with-an-automator-s-5704241
defaults write com.apple.finder CreateDesktop -bool false

# Don't show any special icons on desktop. (These shouldn't really matter when we're already hiding the desktop.)
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

# Start the screensaver after 10 minutes of inactivity.
defaults -currentHost write com.apple.screensaver idleTime -int 600

# Set a black-topped wallpaper so the menu bar reads as black (hides the notch and
# gives a clean black bar). The generator uses only built-in tools (AppKit via
# osascript), so there's nothing extra to install. See wallpaper/.
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
wallpaper_src="$script_dir/wallpaper/jwst-deep-field-smacs0723.jpg"
wallpaper="$HOME/Pictures/Backgrounds/jwst-deep-field-smacs0723.jpg"

mkdir -p "$HOME/Pictures/Backgrounds"

# Both generating and applying the wallpaper drive the window server, which only
# exists inside a logged-in GUI session. Over SSH (as when the VM test harness
# runs this suite) osascript fails with "no main display", so probe for a usable
# session first and report the step as manual rather than aborting the script.
source "${BASH_SOURCE%/*}/../util/colors.sh"
if current_wallpaper="$(osascript -e 'tell application "System Events" to get picture of desktop 1' 2>/dev/null)"; then
    # Generate the black-bar wallpaper once (idempotent: skip if it already exists).
    if [[ ! -f "$wallpaper" ]]; then
        SRC="$wallpaper_src" DST="$wallpaper" \
            osascript -l JavaScript "$script_dir/wallpaper/generate-wallpaper.js"
    fi

    # Apply it only when it exists and isn't already set (idempotent: don't reset
    # every run, and don't point the desktop at a missing file if generation
    # failed). The path is passed as an argument, not interpolated into the
    # AppleScript, so any characters in it are safe.
    if [[ -f "$wallpaper" && "$current_wallpaper" != "$wallpaper" ]]; then
        osascript \
            -e 'on run argv' \
            -e 'tell application "System Events" to set picture of every desktop to (item 1 of argv)' \
            -e 'end run' \
            "$wallpaper"
    fi
else
    printf '%s%s⚠ MANUAL STEP:%s set the desktop wallpaper — no GUI session here.\n' \
        "$BOLD" "$YELLOW" "$RESET"
    printf '    Re-run os/desktop.sh while logged in at the desktop.\n'
fi

# Restart Finder so settings will take effect.
killall Finder

# Install Rectangle window manager.
brew-install-cask rectangle
echo "TODO: Automate: System Settings > Privacy & Security > Device Control and Data Access > ENABLE Rectangle"
open-app Rectangle
echo "TODO: Automate: Rectangle (in menu bar) Settings > ENABLE Launch on login"
echo "TODO: Automate: Rectangle (in menu bar) Settings > ENABLE Check for updates automatically"
echo "TODO: Automate: Rectangle (in menu bar) Settings > ENABLE Remove keyboard shortcut restrictions"
echo "TODO: Automate: Rectangle (in menu bar) Settings > ENABLE Move cursor along with window across displays"
# Leave double-clicking a window's title bar to macOS (Desktop & Dock settings);
# Rectangle's own double-click option conflicts with it. Make the green stoplight
# button maximize the window, instead of going full screen.
defaults write com.knollsoft.Rectangle doubleClickTitleBar -int 0
defaults write com.knollsoft.Rectangle greenButtonOverride -bool true
