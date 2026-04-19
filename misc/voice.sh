#!/bin/bash

## Talon is a speech-to-text-and-commands tool.
## Talon is required for the Cursorless VS Code plugin.

BLUE="$(tput setaf 4)"
RESET="$(tput sgr0)"

brew install --cask --quiet talon
echo "${BLUE}You may be prompted to agree to the EULA.${RESET}"
echo "${BLUE}You may be prompted to enable Accessibility Access:${RESET}"
echo "${BLUE}System Settings / Privacy & Security / Accessibility / ENABLE Talon${RESET}"
open -a Talon.app

echo "${BLUE}You may need to set the microphone in the Talon menu in the menu bar.${RESET}"
echo "${BLUE}You'll probably want to install Conformer from the Talon menu in the menu bar (in the Speech Recognition submenu).${RESET}"

# Download community Talon user files to configure vocabulary/commands/actions.
(cd ~ && mkdir -p .config/talon && ln -s .config/talon .talon)
(cd ~/.config/talon/user && \
    git clone https://github.com/talonhub/community && \
    git clone https://github.com/phillco/talon_axkit && \
    git clone https://github.com/cursorless-dev/cursorless-talon.git
)

# TODO: Install Parrot to enable clicks, pops, etc.
#brew install --quiet six
#brew install --quiet portaudio

# TODO: Other speech recognition engines.
#pip3 install vosk

# Install VS Code extension for TalonScript support.
code --install-extension mrob95.vscode-talonscript
# Install VS Code extensions for Cursorless.
code --install-extension pokey.cursorless
code --install-extension pokey.parse-tree
code --install-extension pokey.command-server
code --install-extension pokey.semantic-movement # Optional.


# Handy is Open Source, uses Whisper Small locally.
brew install --cask --quiet handy
