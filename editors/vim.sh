#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

## Install and configure Vim.


## NOTE: Most Vim configuration will be done via personal config files.


## Installation

# Install from Homebrew, so we get the latest version.
brew install --quiet vim

# Install ctags, to generate indexes to allow us to easily locate things by name.
brew install --quiet ctags

# Install and update Vundle plugins. (Assumes .vimrc loads Vumdle and lists plugins.)
vim -c 'VundleInstall' -c 'VundleUpdate' -c 'qa!'
