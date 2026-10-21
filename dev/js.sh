#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

# Dependencies: `mise`

## Install Bun. (Versions come from ~/.config/mise/config.toml.)
mise install bun

# TODO: See if there are any old versions we want to get rid of. Maybe ask?
#           Use `mise uninstall bun 1.2.3`
#           Maybe set an `at` to remind you to run the script again?

# Define more reasonable locations for Bun packages.
# NOTE: You'll also need these in your `bunfig.toml` or shell startup files.
export BUN_INSTALL="${XDG_DATA_HOME:-$HOME/.local/share}/bun"
export BUN_INSTALL_BIN="${XDG_BIN_HOME:-$HOME/.local/bin}"
export BUN_INSTALL_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/bun"

## Install Node.
mise install node
