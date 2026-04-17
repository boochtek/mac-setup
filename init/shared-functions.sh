# This file is sourced to load common shared functions.

# This should work in Bash or Zsh (maybe others), but tell shellcheck it's Bash:
# shellcheck shell=bash

# Make sure this file is only loaded once.
if [[ ! -z "$SHARED_FUNCTIONS_LOADED" ]]; then
    return
else
    export SHARED_FUNCTIONS_LOADED=1
fi


# TODO: Determine if we should use `command -v` instead of `type -p`.
command-exists() {
    type -p "$1" >/dev/null
}

# TODO: Better name?
require-brew() {
    if ! brew list --versions "$1" >/dev/null; then
        brew install --quiet "$1"
    fi
}

require-cask() {
    if ! brew list --cask --versions "$1" >/dev/null; then
        brew install --quiet --cask "$1"
    fi
}

require-gem() {
    if [[ gem list --quiet --local --installed "^$1\$" > /dev/null ]]; then
        echo gem install "$1"
    fi
}
