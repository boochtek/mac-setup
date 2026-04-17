#!/bin/bash

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


# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs).
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3


# Disable automatic fancy quotes and dashes (because I don't want those changes when I'm coding).
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -boolean false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -boolean true


brew install --quiet --cask karabiner-elements # Requires password.
sudo mkdir -p /usr/local/bin
cat > /usr/local/bin/karabiner <<'EOF' # Can’t soft-link the binary. See https://github.com/tekezo/Karabiner/issues/194
#!/bin/sh
/Library/Application\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli $@
EOF
chmod +x /usr/local/bin/karabiner

# Start Karabiner
# TODO: Had to manually go into Security & Privacy preferences, Privacy Tab, Accessibility, and enable Karabiner_AXNotifier.
open -a Karabiner-Elements


defaults write -app Karabiner isStatusWindowEnabled 0
# Hide Karabiner menubar icon.
defaults write -app Karabiner isStatusbarEnable 0
karabiner reloadxml
IS_LAPTOP=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Model Identifier" | grep "Book")
if $IS_LAPTOP; then
    karabiner enable remap.fnletter_to_ctrlletter
fi
karabiner enable remap.pc_application2controlL # Or remap.jis_pc_application2controlL_capslock, if you want CapsLock by itself to work as CapsLock.


# TODO: Enable Fn-to-Insert mappings if not on laptop (or if we can identify Apple keyboard with numeric keypad. Better yet, only enable them in the XML file for that keyboard device.

# TODO: For desktop keyboard, would like to use PC Style Copy/Paste #3, but that would require changing Fn key to Insert key. (And I don’t think I’ve been able to figure out how to do that.)


# TODO: Can we get OPTION_R or OPTION_L by itself to do ^F2 (move focus to menu bar in Keyboard/Shortcuts/Keyboard)? NOTE: I usually remap that to Command+/.

# TODO: F2 in Finder to rename, but not if in a text field.
# TODO: Enter in Finder to open, but not if in a text field.


# TODO: Check “Use all F1, F2, etc. keys as standard function keys.
# TODO: Adjust keyboard brightness in low light; turn off when computer not used for: 5 min
# TODO: --- to — (em dash).

# TODO: See these web pages:
#			http://apple.stackexchange.com/questions/13598/updating-modifier-key-mappings-through-defaults-command-tool#comment103161_88096
#			http://superuser.com/questions/590526/switch-function-keys-on-os-x-via-via-command-line


## Configuration of my Drop (Massdrop) CTRL keyboard.
# NOTE: QMK has a ton of dependencies; Homebrew will take a while to download/compile them.
brew install qmk/qmk/qmk

## Install Massdrop firmware loader
wget https://github.com/Massdrop/mdloader/releases/download/1.0.3/mdloader_mac -O /usr/local/sbin/mdloader
chmod 0555 /usr/local/sbin/mdloader
chgrp admin /usr/local/sbin/mdloader


## Key bindings (shortcuts) for apps.

# NOTE: Use \u200b (zero-width space) to disable a shortcut for a menu item.
# NOTE: We can replace `-g` with the app name (in reverse DNS form) for app-specific bindings.
# NOTE: For a menu item in the preferences like A->B-C, use "\033A\033B\033C".

# Allow Ctrl+PageDown and Ctrl+PageUp to cycle between tabs, same as Ctrl+Tab and Ctrl+Shift+Tab.
# FIXME: We'll probably have to use Karabiner to allow 2 sets of bindings for the same function.
defaults write -g NSUserKeyEquivalents -dict-add "Next Tab" -string "^\UF72D"
defaults write -g NSUserKeyEquivalents -dict-add "Previous Tab" -string "^\UF72C"
defaults write -g NSUserKeyEquivalents -dict-add "Select Next Tab" -string "^\UF72D"
defaults write -g NSUserKeyEquivalents -dict-add "Select Previous Tab" -string "^\UF72C"
defaults write -g NSUserKeyEquivalents -dict-add "Show Next Tab" -string "^\UF72D"
defaults write -g NSUserKeyEquivalents -dict-add "Show Previous Tab" -string "^\UF72C"

# TODO: Might have to try \U21E5 instead of \t. Might also need to limit this to Terminal.
defaults write -g NSUserKeyEquivalents -dict-add "Show Next Tab" -string "$(echo -e '^\t')"
defaults write -g NSUserKeyEquivalents -dict-add "Show Previous Tab" -string "$(echo -e '^$\t')"




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
