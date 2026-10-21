#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

# NOTE: I'm moving away from using `asdf` in favor of `mise`.

source "${BASH_SOURCE%/*}/../util/colors.sh"

## Install Mise version manager.
brew install --quiet mise

# If Mise has not been activated, tell user how to add it to startup scripts.
# (Activating it here would only affect this script's shell.)
if [[ -z "${MISE_SHELL:-}" ]]; then
    echo "${BLUE}You'll need to add this to your \`~/.bash_profile\` or \`.zshrc\`:"
    echo "${BLUE}    eval \"\$(mise activate)\"${RESET}"
fi
