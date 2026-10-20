#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

## Configure keyboard.

# Use function keys as standard function keys. (Require Fn modifier key to enable special media functions.)
# Use all F1, F2, etc. keys as standard function keys
# NOTE: This requires a reboot to take effect. See http://apple.stackexchange.com/questions/59178 for details.
# NOTE: This doesn't really do anything with the Touch Bar.
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Automatically illuminate built-in MacBook keyboard in low light.
defaults write com.apple.BezelServices kDim -bool true

# Turn off keyboard illumination when computer is not used for 5 minutes.
defaults write com.apple.BezelServices kDimTime -int 300

echo "Please go to System Preferences > Keyboard > Keyboard Shortcuts > Modifier Keys,"
echo "and set Globe/Fn to send Control, Control to send Option, and Option to send Globe/Fn."
echo "Be sure you set it on the laptop's INTERNAL keyboard."

# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs).
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable automatic fancy quotes and dashes (because I don't want those changes when I'm coding).
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -boolean false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -boolean true

# Cache the sudo password. Doesn't help. :(
# sudo -v

# Install Karabiner-Elements.
brew install --quiet --cask karabiner-elements # Requires password.

# Create a symlink to the Karabiner CLI, so we can use it in scripts.
sudo mkdir -p /usr/local/bin
# Can’t soft-link the binary. See https://github.com/tekezo/Karabiner/issues/194
sudo tee /usr/local/bin/karabiner <<'EOF'
#!/bin/sh
/Library/Application\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli $@
EOF
sudo chmod +x /usr/local/bin/karabiner

# Tell user how to manually give Karabiner-Elements the proper access.
echo "Please go to System Preferences > Privacy & Security > Privacy > Accessibility and enable Karabiner-Elements."
echo "Please go to System Preferences > General > Login Items & Extensions > Allow in the Background > ENABLE both Karabiner items."
echo "Please go to System Preferences > General > Login Items & Extensions > Extensions > click on (ⓘ) next to Driver Extensions > ENABLE Karabiner virtual HID device driver."

# TODO: F2 in Finder to rename, but not if in a text field.
# TODO: Enter in Finder to open, but not if in a text field.

# TODO: Check “Use all F1, F2, etc. keys as standard function keys.
# TODO: Adjust keyboard brightness in low light; turn off when computer not used for: 5 min
# TODO: --- to — (em dash).

# TODO: See these web pages:
#			http://apple.stackexchange.com/questions/13598/updating-modifier-key-mappings-through-defaults-command-tool#comment103161_88096
#			http://superuser.com/questions/590526/switch-function-keys-on-os-x-via-via-command-line

## Key bindings (shortcuts) for apps.

# NOTE: Use \u200b (zero-width space) to disable a shortcut for a menu item.
# NOTE: We can replace `-g` with the app name (in reverse DNS form) for app-specific bindings.
# NOTE: For a menu item in the preferences like A->B->C, use "\033A\033B\033C".

# NOTE: Tab cycling (Ctrl+PageDown/PageUp) and CUA clipboard (Shift+Del, Ctrl+Ins,
# Shift+Ins, Ctrl+Del) are deliberately NOT bound here with NSUserKeyEquivalents.
# That mechanism REPLACES a menu item's single shortcut, so it would override
# Command+X/C/V rather than adding the CUA chords as aliases -- and it only binds
# Cocoa menu items. Instead these are key-level remaps in QMK firmware (K1 Pro)
# and Karabiner (internal/other keyboards): the CUA chord sends Command+X/C/V and
# Ctrl+PageDown/Up sends Ctrl+Tab / Ctrl+Shift+Tab, leaving the native Command
# shortcuts intact. See the Karabiner rules "CUA cut and paste (on PC keyboard)"
# and "Control+PageUp/PageDown cycles through tabs", and the K1 Pro QMK PRD (F3-F5).

# TODO: Allow Ctrl+Enter and/or Command+Enter to send emails (Command+Shift+D in Mac Mail).

# TODO: Manually added these (since above didn't work) in Preferences / Keyboard:
#           Ctrl+Tab        Show Next Tab
#           Ctrl+Shift+Tab  Show Previous Tab

# TODO: Manually disabled Ctrl+Up and Ctrl+Down in Preferences / Keyboard / Shortcuts / Mission Control:
#           UNCHECK Mission Control
#           UNCHECK Application windows
# Also disable Ctrl+Left and Ctrl+Right, so we can use them to move by words.
#           UNCHECK Mission Control / Move left a space
#           UNCHECK Mission Control / Move right a space
# This will allow us to use Ctrl+Shift+Up and Ctrl+Shift+Down for Sublime Text multi-line selection.
# NOTE: Ideally, these should all be Command-prefixed, as they're global.

# Pressing and holding a key pops up a menu of alternative related characters.
# NOTE: This doesn't work in terminal apps, but should work for most other text inputs.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool TRUE

# Enable automatic spelling correction (in some places).
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool TRUE
