#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

## Talon is a speech-to-text-and-commands tool.
## Talon is required for the Cursorless VS Code plugin.

BLUE="$(tput setaf 4)"
RESET="$(tput sgr0)"

brew-install-cask talon

# Download community Talon user files to configure vocabulary/commands/actions.
# Do this before Talon first runs; it would create ~/.talon itself.
TALON_USER_DIR=~/.config/talon/user
mkdir -p "$TALON_USER_DIR"
if [[ -L ~/.talon ]]; then
    : # Already linked.
elif [[ -e ~/.talon ]]; then
    echo "${BLUE}~/.talon exists; move its contents to ~/.config/talon, remove it, and re-run.${RESET}"
else
    ln -s .config/talon ~/.talon
fi
for repo in talonhub/community phillco/talon_axkit cursorless-dev/cursorless-talon; do
    repo_dir="$TALON_USER_DIR/${repo#*/}"
    [[ -d "$repo_dir" ]] || git clone "https://github.com/$repo" "$repo_dir"
done

echo "${BLUE}You may be prompted to agree to the EULA.${RESET}"
echo "${BLUE}You may be prompted to enable Accessibility Access:${RESET}"
echo "${BLUE}System Settings / Privacy & Security / Device Control and Data Access / ENABLE Talon${RESET}"
open-app Talon

echo "${BLUE}You may need to set the microphone in the Talon menu in the menu bar.${RESET}"
echo "${BLUE}You'll probably want to install Conformer from the Talon menu in the menu bar (in the Speech Recognition submenu).${RESET}"

# TODO: Install Parrot to enable clicks, pops, etc.
#brew install --quiet six
#brew install --quiet portaudio

# TODO: Other speech recognition engines.
#pip3 install vosk

if command -v code &>/dev/null; then
    # Install VS Code extension for TalonScript support.
    code --install-extension mrob95.vscode-talonscript
    # Install VS Code extensions for Cursorless.
    code --install-extension pokey.cursorless
    code --install-extension pokey.parse-tree
    code --install-extension pokey.command-server
    code --install-extension pokey.semantic-movement # Optional.
else
    echo "${BLUE}Install VS Code (editors/vscode.sh), then re-run this for its Talon extensions.${RESET}"
fi


# Handy is Open Source, uses Whisper Small locally.
brew-install-cask handy
