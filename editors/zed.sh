#!/bin/bash

set -uo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR


# [Zed](https://zed.dev) is a new text editor by the authors of Atom and Tree-sitter.
brew install --quiet --cask --no-quarantine zed

dockutil --add  '/Applications/Zed.app' --replacing 'Zed' --after 'Visual Studio Code' &> /dev/null

# Install the Zed CLI into our path.
ln -sf /Applications/Zed.app/Contents/MacOS/zed /usr/local/bin/ 2>/dev/null || \
    mkdir -p "$HOME/.local/bin/" && ln -sf /Applications/Zed.app/Contents/MacOS/zed "$HOME/.local/bin/"

# Install some tools used by Zed extensions.
npm install -g cspell@latest
npm install -g @cspell/cspell-bundled-dicts@latest

brew install --quiet alesbrelih/gitlab-ci-ls/gitlab-ci-ls

npm install -g markdownlint-lsp

brew install --quiet marksman
brew install --quiet markdown-oxide

brew install --quiet ast-grep
