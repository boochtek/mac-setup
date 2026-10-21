#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

## Install Neovim.
brew install --quiet neovim

## Install VimR, a GUI for Neovim.
brew-install-cask vimr

# Install (optional) prerequisites for LazyVim and Telescope.
brew install --quiet lazygit
brew install --quiet ripgrep # via [telescope](https://github.com/nvim-telescope/telescope.nvim)
brew install --quiet fd # via [telescope](https://github.com/nvim-telescope/telescope.nvim)

# Install prerequisites for nvim-treesitter.
brew install --quiet tree-sitter-cli
