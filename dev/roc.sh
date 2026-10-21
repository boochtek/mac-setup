#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

## Roc is


# Install Roc's dependencies.
brew install --quiet llvm@18 z3

# Install Roc nightly. Add it to `~/.local/bin` (which should be in your $PATH).
cd ~/.local/share
curl -OL https://github.com/roc-lang/roc/releases/download/nightly/roc_nightly-macos_apple_silicon-latest.tar.gz
tar xf roc_nightly-macos_apple_silicon-latest.tar.gz
rm roc_nightly-macos_apple_silicon-latest.tar.gz
rm -rf roc
mv roc_nightly-macos_apple_silicon-* roc
ln -sf "$(pwd)/roc/roc" ~/.local/bin/
ln -sf "$(pwd)/roc/roc_language_server" ~/.local/bin/
cd -

# Install Roc's VS Code extension.
code --install-extension IvanDemchenko.roc-lang-unofficial
# TODO: Set "roc-lang.language-server.exe": "<path to language server binary>" in VS Code settings.

# Install Zulip, the chat platform that Roc developers use.
brew-install-cask zulip
