#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

# TODO: Install via ASDF.

## Lua
# Lua is used by our Hammerspoon and Neovim configs.
brew install --quiet lua

# LuaRocks is Lua's package manager.
brew install --quiet luarocks
